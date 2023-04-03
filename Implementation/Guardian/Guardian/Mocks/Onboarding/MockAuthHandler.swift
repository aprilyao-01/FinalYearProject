//
//  MockAuth.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import FirebaseAuth

/// protocol and extension to mock user
protocol UserProtocol {
    var uid: String { get }
}

extension FirebaseAuth.User: UserProtocol { }

class MockUser: UserProtocol {
    var uid: String
    
    init(uid: String) {
        self.uid = uid
    }
}

/// protocol for testing SessionService() and MapVM() report related
protocol AuthHandler {
    var currentUser: UserProtocol? { get }
    func signOut() throws
}

/// wrapper, to conforms to AuthHandler()
class FirebaseAuthWrapper: AuthHandler {
    private let auth: Auth

    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }

    var currentUser: UserProtocol? {
        return auth.currentUser
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}


/// mock class for testing SessionService()
class MockAuthHandler: AuthHandler {
    var signOutCalled = false
    var mockCurrentUser: UserProtocol?

    func signOut() throws {
        signOutCalled = true
    }
    
    var currentUser: UserProtocol? {
        return mockCurrentUser
    }
}
