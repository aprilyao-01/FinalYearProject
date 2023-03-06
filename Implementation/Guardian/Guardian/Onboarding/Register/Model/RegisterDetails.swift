//
//  RegisterDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 06/12/2023.
//

import Foundation

struct RegisterDetails {
    
    var userName: String
    var email: String
    var password: String
    
    var PIN: String
//    var phoneNo: String
    var fullName: String
    var userID: String
    
//    var lastName: String
}

extension RegisterDetails {
    static var new: RegisterDetails {
        RegisterDetails(userName: "", email: "", password: "", PIN: "", fullName: "", userID: "")
    }
}
