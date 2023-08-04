//
//  LoginView.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 03/08/2023.
//

import SwiftUI
import Combine
import FirebaseAnalyticsSwift
import AuthenticationServices

private enum FocusableField: Hashable {
    case email
    case password
}


struct LoginView: View {
    @EnvironmentObject
    var viewModel: AuthenticationViewModel
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @Environment(\.dismiss)
    var dismiss
    
    @FocusState
    private var focus: FocusableField?
    
    var body: some View {
        VStack {
            HStack {
                Image(colorScheme == .light ? "logo-light" : "logo-dark")
                    .resizable()
                    .frame(width: 30, height: 30 , alignment: .center)
                    .cornerRadius(8)
                Text("Make It So")
                    .font(.title)
                    .bold()
            }
            .padding(.horizontal)
            VStack {
                Image(colorScheme == .light ? "auth-hero-light" : "auth-hero-dark")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .padding(.vertical, 24)
                
                Text("Get your work done. Make it so.")
                    .font(.title2)
                    .padding(.bottom, 16)
            }
            
            GoogleSignInButton(.signIn) {
                // sign in with Google
            }
            
            SignInWithAppleButton(.signIn) { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                Task {
                    if await viewModel.handleSignInWithAppleCompletion(result) {
                        dismiss()
                    }
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .cornerRadius(8)
        }
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
