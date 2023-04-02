//
//  MockAccount.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import FirebaseAuth

class TestAccountViewModel: AccountVM {
    var testUsers: [String: User] = [:]

    override func saveUserDetails() {
        var uid: String
        if Auth.auth().currentUser == nil {
            uid = "test"
        } else {
            uid = Auth.auth().currentUser!.uid
        }

        testUsers[uid] = currentUser
    }

    override func fetchCurrentUser() {
        var uid: String
        if Auth.auth().currentUser == nil {
            uid = "test"
        } else {
            uid = Auth.auth().currentUser!.uid
        }

        guard let user = testUsers[uid] else {
            return
        }

        currentUser = user
    }
}
