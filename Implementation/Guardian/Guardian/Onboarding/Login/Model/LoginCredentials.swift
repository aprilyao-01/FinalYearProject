//
//  LoginCredentials.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
    var phoneNo: String
    var OTP: String
}

extension LoginCredentials {
    static var new: LoginCredentials{
        LoginCredentials(email: "", password: "", phoneNo: "", OTP: "")
    }
}
