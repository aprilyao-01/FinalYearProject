//
//  User.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation

struct User: Codable,Hashable{
    var userId: String
    var userName: String
    var fullName: String
    var phoneNo: String
    var PIN: String
    var userImage: String
}
