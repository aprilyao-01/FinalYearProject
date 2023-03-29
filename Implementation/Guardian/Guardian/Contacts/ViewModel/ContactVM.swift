//
//  ContactVM.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol ContactViewModel {
    func addContact()
    func fetchContact()
    func deleteContact(item: EmergencyContact?)
    func updateContact(item: EmergencyContact)
}

class ContactVM: ObservableObject, ContactViewModel {
    @Published var selectedContacts: [EmergencyContact] = []
    @Published var fetchedContactList: [EmergencyContact] = []
    @Published var contactAddErrorMessage: String = ""
    
    // database reference
    let ref: DatabaseReference! = Database.database().reference()
    let activityIndicator = ActivityIndicator()
    
    
    func addContact() {
        // avoid repeat contacts
        var contactsNotAdded: [String] = []
        
        do{
            let currentUID = Auth.auth().currentUser!.uid
            for item in selectedContacts{
                let existingContacts = fetchedContactList.filter({$0.phoneNo == item.phoneNo})
                if existingContacts.count == 0{
                    //This block of code used to convert object models to json string
                    let jsonData = try JSONEncoder().encode(item)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    ref.child("contact").child(currentUID).child(item.id).setValue(SharedMethods().jsonToDictionary(from: jsonString))
                }else{
                    contactsNotAdded.append(item.phoneNo)
                }
            }
            if contactsNotAdded.count > 0{
                contactAddErrorMessage = "Following phone number/s were not added as they already exists.\n\(contactsNotAdded.joined(separator: ", "))"
            }
        }catch{
            print("ContactVM: cannot add contact\n %s", error)
        }
    }
    
    func fetchContact() {
        //MARK: loading
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        
        var currentUID : String
        if Auth.auth().currentUser == nil {
            currentUID = "test"
            DispatchQueue.main.async{
                self.activityIndicator.hideActivityIndicator()
            }
        } else {
            currentUID = Auth.auth().currentUser!.uid
            
            _ = ref.child("contact").child(currentUID).observe(DataEventType.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                
                let contactListArray = value?.allValues
                do {
                    let json = try JSONSerialization.data(withJSONObject: contactListArray ?? [])
                   
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedContacts = try decoder.decode([EmergencyContact].self, from: json)
                    self.fetchedContactList = decodedContacts
                    
//                    print(self.fetchedContactList)
                    //MARK: dismiss loading
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                } catch {
                    print("ContactVM: cannot fetch contact\n %s", error)
                }
            })
        }
    }
    
    func deleteContact(item: EmergencyContact?) {
        let currentUID = Auth.auth().currentUser!.uid
        ref.child("contact").child(currentUID).child(item?.id ?? "").removeValue()
    }
    
    func updateContact(item: EmergencyContact) {
        do{
            let currentUID = Auth.auth().currentUser!.uid
            let jsonData = try JSONEncoder().encode(item)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("contact").child(currentUID).child(item.id).updateChildValues(SharedMethods().jsonToDictionary(from: jsonString) ?? [:])
        }catch{
            print("ContactVM: cannot update contact\n %s", error)
        }
    }
    
    
}
