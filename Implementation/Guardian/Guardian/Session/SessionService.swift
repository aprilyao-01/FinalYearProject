//
//  SessionService.swift
//  Guardian
//
//  Created by Siyu Yao on 03/02/2023.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetail: SessionUserDetails? { get }
    func logout()
}


final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetail: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    //warpper, to easy implement unit testing
    private let authSignOut: AuthHandler

    init(authSignOut: AuthHandler) {
        self.authSignOut = authSignOut
        setupFirebaseAuthHandler()
    }
    
    func logout() {
        try? authSignOut.signOut()
    }
    
    
}


private extension SessionServiceImpl {
    
    func setupFirebaseAuthHandler() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] res, user in
            guard let self = self
            else { return }
            self.state = user == nil ? .loggedOut : .loggedIn
            if let uid = user?.uid {
                self.handleRefresh(with: uid)
            }
        }
    }
    
    func handleRefresh(with uid: String) {
        Database.database().reference().child("user").child(uid).observe(.value) { [weak self] snapshot   in
            
            guard let self = self,
                  let value = snapshot.value as? NSDictionary,
                  let fullName = value[RegisterKeys.fullName.rawValue] as? String,
                  let userName = value[RegisterKeys.userName.rawValue] as? String,
                  let pin = value[RegisterKeys.PIN.rawValue] as? String
            else { return }
            
            DispatchQueue.main.async {
                self.userDetail = SessionUserDetails(fullName: fullName, userName: userName, PIN: pin, userID: uid)
            }
        }
    }
}
