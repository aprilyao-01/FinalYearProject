//
//  ContactPickerView.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import SwiftUI
import Contacts
import ContactsUI

struct ContactPickerView: View {
    
    @Binding var selectedContacts: [EmergencyContact]
    var contactPickingFinished: () -> Void
    
    var body: some View {
        ContactPickerVM { contacts in
            self.selectedContacts = []
            for contact in contacts {
                if let phone = contact.phoneNumbers.first?.value as? CNPhoneNumber {
                    let contactItem = EmergencyContact(contactName: "\(contact.givenName) \(contact.familyName)", isEmergencyContact: true, phoneNo: phone.stringValue, profileImage: "")
                    self.selectedContacts.append(contactItem)
                }
            }
            self.contactPickingFinished()
        }
    }
}


struct ContactPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = EmergencyContact(contactName: "John Preview", isEmergencyContact: true, phoneNo: "23455678", profileImage: "")
        
        ContactPickerView(selectedContacts: .constant([sample]), contactPickingFinished: {})
    }
}
