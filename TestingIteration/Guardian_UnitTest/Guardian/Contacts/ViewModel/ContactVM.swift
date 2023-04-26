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
    func addContact(completion: @escaping (Bool) -> Void)
    func fetchContact(completion: @escaping (Bool) -> Void)
    func deleteContact(item: EmergencyContact?, completion: @escaping (Bool) -> Void)
    func updateContact(item: EmergencyContact, completion: @escaping (Bool) -> Void)
}

class ContactVM: ObservableObject, ContactViewModel {
   
    
    
    @Published var selectedContacts: [EmergencyContact] = []
    @Published var fetchedContactList: [EmergencyContact] = []
    @Published var contactAddErrorMessage: String = ""
    
    // database reference
//    let ref: DatabaseReference! = Database.database().reference()
//    let activityIndicator = ActivityIndicator()
    
    // MARK: update for unit test
    // Change the properties to non-private and non-constant
    var ref: DatabaseReferenceProtocol
    var authHandler: AuthHandler
    var activityIndicator: ActivityIndicatorProtocol
    
    // Add an initializer to accept the dependencies as parameters
    init(ref: DatabaseReferenceProtocol = DatabaseReferenceWrapper(Database.database().reference()),
         authHandler: AuthHandler = FirebaseAuthWrapper(),
         activityIndicator: ActivityIndicatorProtocol = ActivityIndicatorWrapper(activityIndicator: UIActivityIndicatorView())) {
        self.ref = ref
        self.authHandler = authHandler
        self.activityIndicator = activityIndicator
    }

    
    func addContact(completion: @escaping (Bool) -> Void) {
        // avoid repeat contacts
        var contactsNotAdded: [String] = []
        
        do {
            var currentUID: String
            if authHandler.currentUser == nil {
                currentUID = "test"
            } else {
                currentUID = authHandler.currentUser!.uid
            }
            print("Before the loop")
            for item in selectedContacts {
                print("Inside the loop")
                let existingContacts = fetchedContactList.filter({ $0.phoneNo == item.phoneNo })
                if existingContacts.count == 0 {
                    print("Setting value")
                    // This block of code used to convert object models to JSON string
                    let jsonData = try JSONEncoder().encode(item)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    ref.child("contact").child(currentUID).child(item.id).setValue(SharedMethods().jsonToDictionary(from: jsonString)) { error, reference in
                        print("Inside setValue completion block")
                        if let error = error {
                          //  self.activityIndicator.hideActivityIndicator()
                            SharedMethods.showMessage("Error", message: error.localizedDescription, onVC: UIApplication.topViewController())
                            completion(false) // Call the completion closure

                        } else {
                           // self.activityIndicator.hideActivityIndicator()
                            print("Completion called")
                            completion(true) // Call the completion closure
                        }
                    }
                } else {
                    print("Contact already exists")
                    contactsNotAdded.append(item.phoneNo)
                    completion(true)

                }
            }
            print("After the loop")
            if contactsNotAdded.count > 0 {
                contactAddErrorMessage = "Following phone number/s were not added as they already exist.\n\(contactsNotAdded.joined(separator: ", "))"
            }
        } catch {
            print("ContactVM: cannot add contact\n %s", error)
            completion(false) // Call the completion closure

        }
    }
    
    func fetchContact(completion: @escaping (Bool) -> Void) {
        //MARK: loading
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        
        var currentUID : String
        if authHandler.currentUser == nil {
            currentUID = "test"
            DispatchQueue.main.async{
                self.activityIndicator.hideActivityIndicator()
            }
            
            completion(false)

        } else {
            currentUID = authHandler.currentUser!.uid
            print("-- ID: \(authHandler.currentUser!.uid)")
            
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
                    
                    completion(true)
                    
                } catch {
                    print("ContactVM: cannot fetch contact\n %s", error)
                    completion(false)

                }
            })
        }
    }
    
    func deleteContact(item: EmergencyContact?, completion: @escaping (Bool) -> Void) {
        let currentUID: String
        if authHandler.currentUser == nil {
            currentUID = "test"
        } else {
            currentUID = authHandler.currentUser!.uid
        }
        ref.child("contact").child(currentUID).child(item?.id ?? "").removeValue(completionBlock: { error, result in
            if error == nil {
                completion(true)

//                DispatchQueue.main.async {
//                    self.activityIndicator.hideActivityIndicator()
//                }
            } else {
                
                completion(false)
//                DispatchQueue.main.async {
//                    self.activityIndicator.hideActivityIndicator()
//                    SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
//                }
                
            }

           // Call the completion closure
        })
    }
    
    
    
    
    func updateContact(item: EmergencyContact, completion: @escaping (Bool) -> Void) {
        do {
            let currentUID: String
            if authHandler.currentUser == nil {
                currentUID = "test"
            } else {
                currentUID = authHandler.currentUser!.uid
            }
            let jsonData = try JSONEncoder().encode(item)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("contact").child(currentUID).child(item.id).updateChildValues(SharedMethods().jsonToDictionary(from: jsonString) ?? [:], withCompletionBlock: { error, result in
                if error == nil {
//                    DispatchQueue.main.async {
//                        self.activityIndicator.hideActivityIndicator()
//                    }
                    completion(true)
                    
                } else {
//                    DispatchQueue.main.async {
//                        self.activityIndicator.hideActivityIndicator()
//                        SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
//                    }
                    completion(false)

                }

                // Call the completion closure
            })
        } catch {
            print("ContactVM: cannot update contact\n %s", error)
            completion(false)

        }
    }
}
