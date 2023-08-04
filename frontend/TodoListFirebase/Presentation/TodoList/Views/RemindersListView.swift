//
//  RemindersListView.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 21/07/2023.
//

import SwiftUI

struct RemindersListView: View {
    
    @StateObject
    private var viewModel = RemindersListViewModel()
    
    @State
    private var editableReminder: Reminder? = nil
    
    @State
    private var isAddReminderDialogPresented = false
    
    private func presentAddReminderView() {
        isAddReminderDialogPresented.toggle()
    }
    
    @State
    private var isSettingsScreenPresented = false
    
    private func presentSettingsScreen() {
        isSettingsScreenPresented.toggle()
    }
    
    var body: some View {
        List($viewModel.reminders) { $reminder in
            RemindersListRowView(reminder: $reminder)
                .swipeActions(content: {
                    Button(role: .destructive) {
                        viewModel.deleteReminder(reminder)
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                })
                .onChange(of: reminder.isCompleted) { newValue in
                    viewModel.setCompleted(reminder, isCompleted: newValue)
                }
                .onTapGesture {
                    editableReminder = reminder
                }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: presentSettingsScreen) {
                    Image(systemName: "gearshape")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: presentAddReminderView) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isAddReminderDialogPresented) {
            EditReminderDetailsView { reminder in
                viewModel.addReminder(reminder)
            }
        }
        // When `$editableReminder` updated. Come here
        .sheet(item: $editableReminder) { reminder in
            EditReminderDetailsView(reminder: reminder, mode: .edit) { reminder in
                viewModel.updateReminder(reminder)
            }
        }
        .sheet(isPresented: $isSettingsScreenPresented) {
            SettingsView()
        }
        .tint(.red)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RemindersListView()
                .navigationTitle("Reminders")
        }
    }
}
