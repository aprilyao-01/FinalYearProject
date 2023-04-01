//
//  AccountVM.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

protocol AccountViewModel {
    var fetchedImage: UIImage? { get }
    var currentUser: User { get }
    
    func saveUserDetails()
    func fetchCurrentUser()
    func deleteCurrentUser()
    func changePassword(oldPassword: String,newPassword: String)
    func changePIN(oldPin: String, newPin: String)
    
}

class AccountVM: ObservableObject, AccountViewModel {
    
    @Published var currentUser: User = User(userId: "", userName: "", fullName: "", phoneNo: "", PIN: "", userImage: "")
    
    //profile img properties
    @Published var fetchedImage: UIImage?
    @Published var isProfilePictureChanged: Bool = false
    
    // DatabaseReference
    let ref: DatabaseReference! = Database.database().reference()
    
    let storageRef = Storage.storage().reference()
    let activityIndicator = ActivityIndicator()
    
    // status change properties
    @Published var isUserPinChangeSuccess: Bool = false
    @Published var isUserPasswordChangeSuccess: Bool = false

    func saveUserDetails(){
        //MARK: loading
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        
        var uid : String
        if Auth.auth().currentUser == nil {
            uid = "test"
        } else {
            uid = Auth.auth().currentUser!.uid
        }
        
        do{
            if isProfilePictureChanged {
                if let profile = fetchedImage{
                    currentUser.userImage = profile.toJpegString(compressionQuality: 0.2) ?? ""
                }
            }
            
            let jsonData = try JSONEncoder().encode(currentUser)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("user").child(uid).setValue(SharedMethods().jsonToDictionary(from: jsonString), withCompletionBlock: { error, result  in
                //MARK: dismiss loading
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                }
                if error == nil{
                    SharedMethods.showMessage("Message", message: "Profile details saved successfully", onVC: UIApplication.topViewController())
                }else{
                    SharedMethods.showMessage("Message", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                }
            })
        }catch{
            //MARK: dismiss loading
            DispatchQueue.main.async{
                self.activityIndicator.hideActivityIndicator()
            }
            print("ProfileVM: cannot save user details\n %s", error)
        }
    }
    
    func fetchCurrentUser() {
        var uid : String
        if Auth.auth().currentUser == nil {
            uid = "test"
        } else {
            uid = Auth.auth().currentUser!.uid
        }
        
        let userRef = ref.child("user").child(uid)
        
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }

        userRef.observeSingleEvent(of: .value, with: { [self] snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                    return
                }

            let userId = uid
            let userName = userData["userName"] as? String ?? ""
            let fullName = userData["fullName"] as? String ?? ""
            let phoneNo = userData["phoneNo"] as? String ?? ""
            let PIN = userData["PIN"] as? String ?? ""
            let userImage = userData["userImage"] as? String ?? ""
            
            if userImage != ""{
                fetchedImage = userImage.toImage()
            }

            currentUser = User(userId: userId, userName: userName, fullName: fullName, phoneNo: phoneNo, PIN: PIN, userImage: userImage)
            DispatchQueue.main.async{
                self.activityIndicator.hideActivityIndicator()
            }
        })
    }
    
    func deleteCurrentUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
              SharedMethods.showMessage("Error", message: error.localizedDescription, onVC: UIApplication.topViewController())
          } else {
              if user != nil{
                  self.ref.child("user").child(user!.uid).removeValue()
                  self.ref.child("contact").child(user!.uid).removeValue()
                  self.deleteAllRecordingsFromStorage(useruId: user!.uid)
              }
          }
        }
    }
    
    //MARK: delete user information from database
    func deleteAllRecordingsFromStorage(useruId: String){
            // Get a reference to the directory you want to delete
            let storageRef = Storage.storage().reference().child("recordings/\(useruId)")

            // Call the recursive function to delete all contents of the directory
            deleteAllContents(in: storageRef) { error in
                if let error = error {
                    // An error occurred
                    print(error.localizedDescription)
                } else {
                    // All contents deleted successfully; now delete the directory itself
                    storageRef.delete { error in
                        if let error = error {
                            // An error occurred
                            print(error.localizedDescription)
                        } else {
                            // Directory deleted successfully
                            print("Directory deleted successfully")
                        }
                    }
                }
            }
    }
    
    //MARK: delete user information from database
    func deleteAllContents(in directory: StorageReference, completion: @escaping (Error?) -> Void) {
        directory.listAll { (result, error) in
            if let error = error {
                // An error occurred
                completion(error)
            } else {
                // Delete all files and subdirectories
                let group = DispatchGroup()
                for item in result?.items ?? [] {
                    group.enter()
                    item.delete { error in
                        if let error = error {
                            // An error occurred
                            completion(error)
                        } else {
                            group.leave()
                        }
                    }
                }
                for item in result?.prefixes ?? [] {
                    group.enter()
                    self.deleteAllContents(in: item, completion: { error in
                        if let error = error {
                            // An error occurred
                            completion(error)
                        } else {
                            group.leave()
                        }
                    })
                }
                group.notify(queue: DispatchQueue.global()) {
                    // All files and subdirectories have been deleted
                    completion(nil)
                }
            }
        }
    }
    
    func changePassword(oldPassword: String,newPassword: String){
        isUserPasswordChangeSuccess = false
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: oldPassword)
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        // Prompt the user to re-provide their sign-in credentials
        user?.reauthenticate(with: credential) { result,error  in   //authenticate user before changing password
            if error != nil {
                self.isUserPasswordChangeSuccess = false
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                    SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                }
            } else {
                // User re-authenticated.
                Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in   //change password
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                    if error == nil{
                        self.isUserPasswordChangeSuccess = true
                    }else{
                        self.isUserPasswordChangeSuccess = false
                        SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                    }
                }
            }
        }
    }
    
    func changePIN(oldPin: String, newPin: String){
        isUserPinChangeSuccess = false
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        if currentUser.PIN == oldPin{
            currentUser.PIN = newPin
            do{
                let jsonData = try JSONEncoder().encode(currentUser)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                self.ref.child("user").child(currentUser.userId).setValue(SharedMethods().jsonToDictionary(from: jsonString),withCompletionBlock: { error, result in
                    DispatchQueue.main.async{
                        self.activityIndicator.hideActivityIndicator()
                    }
                    if error == nil{
                        self.isUserPinChangeSuccess = true
                    }else{
                        self.isUserPinChangeSuccess = false
                        SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())
                    }
                })

            }catch{
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                }
            }
        }else{
            DispatchQueue.main.async{
                self.activityIndicator.hideActivityIndicator()
                SharedMethods.showMessage("Error", message: "Please enter the correct old PIN", onVC: UIApplication.topViewController())
            }
        }

    }
}
