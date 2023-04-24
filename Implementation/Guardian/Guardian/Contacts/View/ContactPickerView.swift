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
    
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        
        // MARK: fix bug on ios 15.5
        let navController = UINavigationController()
        navController.present(picker, animated: false, completion: nil)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    // MARK: ViewController Representable delegate methods
    func makeCoordinator() -> ContactsCoordinator {
        return ContactsCoordinator(self)
    }
    
    class ContactsCoordinator: NSObject, UINavigationControllerDelegate, CNContactPickerDelegate {
        
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
