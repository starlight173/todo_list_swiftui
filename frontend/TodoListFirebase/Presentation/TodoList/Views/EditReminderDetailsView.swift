//
//  AddReminderView.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 21/07/2023.
//

import SwiftUI

struct EditReminderDetailsView: View {
    enum FocusableField: Hashable {
        case title
    }
    
    @FocusState
    private var focusedField: FocusableField?
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    var reminder = Reminder(title: "")
    
    enum Mode {
        case add
        case edit
    }
    var mode: Mode = .add
    
    var onCommit: (_ reminder: Reminder) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $reminder.title)
                    .focused($focusedField, equals: .title)
                    // Enter to submit
                    .onSubmit {
                        commit()
                    }
            }
            .navigationTitle(mode == .add ? "New Reminder" : "Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: cancel) {
                        Text("Cancel")
                    }
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: commit) {
                        Text(mode == .add ? "Add" : "Done")
                    }
                    .disabled(reminder.title.isEmpty)
                }
            }
            .onAppear {
                focusedField = .title
            }
        }
    }
    
    private func commit() {
        onCommit(reminder)
        dismiss()
    }
    
    private func cancel() {
        dismiss()
    }
}

struct AddReminderView_Previews: PreviewProvider {
    struct Container: View {
        @State var reminder = Reminder.samples[0]
        var body: some View {
            EditReminderDetailsView(reminder: reminder, mode: .edit) { reminder in
                print("You edited a reminder: \(reminder.title)")
            }
        }
    }
    
    static var previews: some View {
        EditReminderDetailsView { reminder in
            print("You added a reminder: \(reminder.title)")
        }
        Container()
    }
}
