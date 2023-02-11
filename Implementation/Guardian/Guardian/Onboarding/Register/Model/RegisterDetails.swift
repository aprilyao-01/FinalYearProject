//
//  RegisterDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 06/12/2023.
//

import Foundation

struct RegisterDetails {
    
    var phoneNo: String
    var password: String
    var email: String
    var fullName: String
//    var userName: String
    var PIN: String
//    var lastName: String
}

extension RegisterDetails {
    static var new: RegisterDetails {
        RegisterDetails(phoneNo: "", password: "", email: "", fullName: "", PIN: "")
    }
}
