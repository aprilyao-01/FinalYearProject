//
//  ContactPickerView.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import Foundation
import SwiftUI
import Contacts
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedContacts: [EmergencyContact]
    var contactPickingFinished: () -> Void
    
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        
    }
    
    // MARK: ViewController Representable delegate methods
    func makeCoordinator() -> ContactsCoordinator {
        return ContactsCoordinator(self)
    }
    
    class ContactsCoordinator: NSObject, CNContactPickerDelegate {
        
        let parent: ContactPickerView
        
        init(_ parent: ContactPickerView) {
            self.parent = parent
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.selectedContacts = []
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            parent.selectedContacts = []
            for contact in contacts{
                if let phone = contact.phoneNumbers.first?.value as? CNPhoneNumber {
                    let contactItem = EmergencyContact(contactName: "\(contact.givenName) \(contact.familyName)", isEmergencyContact: false, phoneNo: phone.stringValue, profileImage: "")
                    parent.selectedContacts.append(contactItem)
                }
            }
            parent.contactPickingFinished()
        }
    }
}
