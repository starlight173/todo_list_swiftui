//
//  Repository+Injection.swift
//  TodoListFirebase
//
//  Created by Quang Luu on 01/08/2023.
//

import Factory

extension Container {
    
    public var remindersRepository: Factory<RemindersRepository> {
        Factory(self) {
            RemindersRepositoryImp()
        }.singleton
    }
    
    public var authenticationService: Factory<AuthenticationService> {
        self {
            AuthenticationService()
        }.singleton
    }
}
