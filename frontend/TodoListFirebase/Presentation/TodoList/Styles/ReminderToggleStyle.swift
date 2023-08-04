//
//  ReminderToggleStyle.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 31/07/2023.
//

import SwiftUI

struct ReminderToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn
                  ? "largecircle.fill.circle"
                  : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(configuration.isOn ? .accentColor : .gray)
            .imageScale(.large)
            .foregroundColor(.accentColor)
            .onTapGesture {
                configuration.isOn.toggle()
            }
            configuration.label
        }
    }
}

struct ReminderToggleStyle_Previews: PreviewProvider {
    struct Container: View {
        @State var isOn = false
        
        var body: some View {
            VStack {
                Toggle(isOn: .constant(true)) {
                    Text("Hello World")
                }
                .toggleStyle(ReminderToggleStyle())
                
                //
                Toggle(isOn: $isOn) {
                    Text("Hello World")
                }
                .toggleStyle(.reminder)
            }
        }
    }
    
    static var previews: some View {
      Container()
    }
}

extension ToggleStyle where Self == ReminderToggleStyle {
    static var reminder: ReminderToggleStyle {
        ReminderToggleStyle()
    }
}

