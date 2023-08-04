//
//  RemindersListRowView.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 28/07/2023.
//

import SwiftUI

struct RemindersListRowView: View {
    @Binding
    var reminder: Reminder
    
    var body: some View {
        HStack {
//            Image(systemName: reminder.isCompleted ? "largecircle.fill.circle" : "circle")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//                .onTapGesture {
//                    reminder.isCompleted.toggle()
//                }
            Toggle(isOn: $reminder.isCompleted) {
                
            }
            .toggleStyle(.reminder)
            Text(reminder.title)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct RemindersListRowView_Previews: PreviewProvider {
    struct Container: View {
        @State
        var reminder = Reminder.samples[0]
        
        var body: some View {
            List {
                RemindersListRowView(reminder: $reminder)
            }
            .listStyle(.plain)
        }
    }
    
    
    static var previews: some View {
        NavigationView {
            Container()
                .navigationTitle("Reminders")
        }
    }
}
