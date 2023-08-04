//
//  Reminder.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 21/07/2023.
//

import Foundation
import FirebaseFirestoreSwift

public struct Reminder: Identifiable, Codable {
    @DocumentID
    public var id: String?
    var title: String
    var isCompleted = false
    var userId: String? = nil
}

extension Reminder {
  static let collectionName = "reminders"
}

extension Reminder {
    static let samples = [
        Reminder(title: "Build sample app", isCompleted: true),
        Reminder(title: "Create tutorial"),
        Reminder(title: "???"),
        Reminder(title: "PROFIT!"),
    ]
}
