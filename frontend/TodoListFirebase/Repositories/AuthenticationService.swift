//
//  AuthenticationService.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 03/08/2023.
//

import Foundation
import Factory
import FirebaseAuth
import AuthenticationServices

public class AuthenticationService {
    @Injected(\.auth)
    private var auth
    
    @Published
    var user: User?
    
    @Published
    var errorMessage = ""
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    private var currentNonce: String?
    
    
    
    init() {
        registerAuthStateHandler()
        signInAnonymously()
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = auth.addStateDidChangeListener({ auth, user in
                self.user = user
            })
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Error while trying to sign out: \(error.localizedDescription)")
        }
    }
}

// MARK: - Sign in anonymously
extension AuthenticationService {
    func signInAnonymously() {
        if auth.currentUser == nil {
            print("Nobody is signed in. Trying to sign in anonymously.")
            auth.signInAnonymously()
        } else {
            if let user = auth.currentUser {
                print("Someone is signed in with \(user.providerID) and user ID \(user.uid)")
            }
        }
    }
}

// MARK: - Sign in with Apple
extension AuthenticationService {
    @MainActor
    func handleSignInWithAppleCompletion(withAccountLinking: Bool = false, _ result: Result<ASAuthorization, Error>) async -> Bool {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
            return false
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    return false
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return false
                }
                
                // use this call to create the authentication credential and set the user's full name
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                
                do {
                    if withAccountLinking {
                        let authResult = try await user?.link(with: credential)
                        self.user = authResult?.user
                    } else {
                        try await auth.signIn(with: credential)
                    }
                } catch {
                    print("Error authenticating: \(error.localizedDescription)")
                    return false
                }
                
            }
        }
        return false
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        
        do {
            let nonce = try CryptoUtils.randomNonceString()
            currentNonce = nonce
            request.nonce = CryptoUtils.sha256(nonce)
        } catch {
            print("Error when creating a nonce: \(error.localizedDescription)")
        }
    }
}
