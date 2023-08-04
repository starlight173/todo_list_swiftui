//
//  RemindersListViewModel.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 24/07/2023.
//

import Foundation
import Combine
import Factory

class RemindersListViewModel: ObservableObject {
    @Published
    var reminders = [Reminder]()
    
    @Published
    var errorMessage: String?
    
    // MARK: - Dependencies
    @Injected(\.remindersRepository)
    private var remindersRepository: RemindersRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // Subscribe to the view model's name publisher
        // and get notify when name is set or updated
        // Subscriber 1 and 2 are doing the samething
        // Just to test
        // Subscriber 1
        //        remindersRepository
        //            .remindersPublisher
        //            .receive(on: DispatchQueue.main)
        //            .sink {[weak self] items in
        //                self?.reminders = items
        //            }.store(in: &cancellables)
        
        // Subscriber 2
        remindersRepository
            .remindersPublisher
            .assign(to: &$reminders)
        
    }
    
    func addReminder(_ reminder: Reminder) {
        //reminders.append(reminder)
        do {
            try remindersRepository.addReminder(reminder)
            errorMessage = nil
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func setCompleted(_ reminder: Reminder, isCompleted: Bool = true) {
        var editedReminder = reminder
        editedReminder.isCompleted = true
        updateReminder(editedReminder)
    }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try remindersRepository.updateReminder(reminder)
            errorMessage = nil
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        remindersRepository.removeReminder(reminder)
    }
    
    func toggleCompleted(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id} ) {
            reminders[index].isCompleted.toggle()
        }
    }
}
