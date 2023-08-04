//
//  TodoListFirebaseApp.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 21/07/2023.
//

import SwiftUI
import Factory
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    @LazyInjected(\.authenticationService)
    private var authenticationService
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        
        authenticationService.signInAnonymously()
        
        return true
    }
}

@main
struct TodoListFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RemindersListView()
                    .navigationTitle("Reminders")
            }
        }
    }
}
