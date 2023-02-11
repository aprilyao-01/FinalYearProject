//
//  ContactVM.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import Foundation
//import UIKit
import FirebaseDatabase

protocol ContactViewModel {
    func addContact()
    func fetchContact()
    func deleteContact(item: EmergencyContact?)
    func updateContact(item: EmergencyContact)
}

class ContactVM: ObservableObject, ContactViewModel {
    @Published var selectedContacts: [EmergencyContact] = []
    @Published var fetchedContactList: [EmergencyContact] = []
    
    let ref: DatabaseReference! = Database.database().reference()
//    let activityIndicator = Loading()
    let activityIndicator = ActivityIndicator()
    // TODO: replace this loading
//    @Published var isLoading: Bool = false
    
    
    func addContact() {
        do{
            for item in selectedContacts{
                //This block of code used to convert object models to json string
                let jsonData = try JSONEncoder().encode(item)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                ref.child("contact").child(SettingsStore().currentUserId).child(item.id).setValue(SharedMethods().jsonToDictionary(from: jsonString))
            }
        }catch{
            print("ContactVM: cannot add contact\n %s", error)
        }
    }
    
    func fetchContact() {
        DispatchQueue.main.async{
//            self.activityIndicator.isAnimating = true
            self.activityIndicator.showActivityIndicator()

        }
        _ = ref.observe(DataEventType.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let contactList = value?["contact"] as? NSDictionary
            let contactItemList = contactList?[SettingsStore().currentUserId] as? NSDictionary
            let contactListArray = contactItemList?.allValues
            
            do {
                let json = try JSONSerialization.data(withJSONObject: contactListArray ?? [])
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedContacts = try decoder.decode([EmergencyContact].self, from: json)
                self.fetchedContactList = decodedContacts
                print(self.fetchedContactList)
                DispatchQueue.main.async{
//                    self.activityIndicator.isAnimating = false
                    self.activityIndicator.hideActivityIndicator()
                }
            } catch {
                print("ContactVM: cannot fetch contact\n %s", error)
            }
        })
    }
    
    func deleteContact(item: EmergencyContact?) {
        ref.child("contact").child(SettingsStore().currentUserId).child(item?.id ?? "").removeValue()
    }
    
    func updateContact(item: EmergencyContact) {
        do{
            let jsonData = try JSONEncoder().encode(item)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("contact").child(SettingsStore().currentUserId).child(item.id).updateChildValues(SharedMethods().jsonToDictionary(from: jsonString) ?? [:])
        }catch{
            print("ContactVM: cannot update contact\n %s", error)
        }
    }
    
    
}
