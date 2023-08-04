//
//  SettingView.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 02/08/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @StateObject
    var viewModel = SettingsViewModel()
    
    @State
    var isShowSignUpDialogPresented = false
    
    private func signUp() {
        isShowSignUpDialogPresented.toggle()
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: UserProfileView()) {
                        Label("Account", systemImage: "person.circle")
                    }
                }
                Section {
                    if viewModel.isGuestUser {
                        Button(action: signUp) {
                            HStack {
                                Spacer()
                                Text("Sign up")
                                Spacer()
                            }
                        }
                    } else {
                        Button(action: signOut) {
                            HStack {
                                Spacer()
                                Text("Sign out")
                                Spacer()
                            }
                        }
                    }
                } footer: {
                    HStack {
                        Spacer()
                        Text(viewModel.loggedInAs)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { dismiss() }) {
                        Text("Done")
                    }
                }
            }
            .sheet(isPresented: $isShowSignUpDialogPresented) {
                AuthenticationView()
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
