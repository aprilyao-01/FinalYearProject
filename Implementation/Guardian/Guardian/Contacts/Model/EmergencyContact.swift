//
//  EmergencyContact.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import Foundation

struct EmergencyContact: Codable,Hashable{
    var id: String = UUID().uuidString
    var contactName: String
    var isEmergencyContact: Bool
    var phoneNo: String
    var profileImage: String
}
