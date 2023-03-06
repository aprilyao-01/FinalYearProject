//
//  ContactPickerVM.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import Foundation
import SwiftUI
import Contacts
import ContactsUI

struct ContactPickerVM: UIViewControllerRepresentable {
    
    let onSelect: ([CNContact]) -> Void
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        
        let parent: ContactPickerVM
        
        init(_ parent: ContactPickerVM) {
            self.parent = parent
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            picker.dismiss(animated: true)
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            parent.onSelect(contacts)
            picker.dismiss(animated: true)
        }
    }
}
