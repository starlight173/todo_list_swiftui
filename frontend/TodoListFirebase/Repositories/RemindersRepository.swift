//
//  RemindersRepository.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 31/07/2023.
//

import Foundation
import Factory
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

public protocol RemindersRepository {
    var remindersPublisher: Published<[Reminder]>.Publisher { get }
    func addReminder(_ reminder: Reminder) throws
    func updateReminder(_ reminder: Reminder) throws
    func removeReminder(_ reminder: Reminder)
}

class RemindersRepositoryImp: ObservableObject, RemindersRepository {
    // MARK: - Dependencies
    @Injected(\.firestore) var firestore
    
    @Injected(\.authenticationService) var authenticationService
    
    // Streaming
    @Published
    var reminders = [Reminder]()
    var remindersPublisher: Published<[Reminder]>.Publisher { $reminders }
    
    @Published
    var user: User?
    
    private var listenerRegistration: ListenerRegistration?
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        authenticationService.$user
            .assign(to: &$user)
        
        $user.sink { user in
            self.unsubscribe()
            self.subscribe(user: user)
        }
        .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func addReminder(_ reminder: Reminder) throws {
        var reminder = reminder
        reminder.userId = user?.uid
        
        _ = try firestore
            .collection(Reminder.collectionName)
            .addDocument(from: reminder)
    }
    
    func updateReminder(_ reminder: Reminder) throws {
        guard let documentId = reminder.id else {
            fatalError("Reminder \(reminder.title) has no document ID.")
        }
        
        try firestore
            .collection(Reminder.collectionName)
            .document(documentId)
            .setData(from: reminder, merge: true)
        
    }
    
    func removeReminder(_ reminder: Reminder) {
        guard let documentId = reminder.id else {
            fatalError("Reminder \(reminder.title) has no document ID.")
        }
        
        firestore
            .collection(Reminder.collectionName)
            .document(documentId)
            .delete()
        
    }
    
    func subscribe(user: User? = nil){
        if listenerRegistration == nil {
            if let localUser = user ?? self.user {
                let query = firestore.collection(Reminder.collectionName)
                    .whereField("userId", isEqualTo: localUser.uid)
                
                listenerRegistration = query
                    .addSnapshotListener {[weak self] snapshot, error in
                        guard let documents = snapshot?.documents else {
                            print("No documents")
                            return
                        }
                        
                        print("Mapping \(documents.count) documents")
                        self?.reminders = documents.compactMap { queryDocumentSnapshot in
                            do {
                                return try queryDocumentSnapshot.data(as: Reminder.self)
                            }
                            catch {
                                print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                                return nil
                            }
                        }
                    }
            }
        }
    }
    
    func unsubscribe(){
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
}
