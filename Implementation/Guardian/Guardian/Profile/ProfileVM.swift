//
//  ProfileVM.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol ProfileViewModel {
//    var activityIndicator: ActivityIndicator { get }
    var fetchedImage: UIImage? { get }
    
    func saveUserDetails()
    func fetchCurrentUser()
    
}

class ProfileVM: ObservableObject, ProfileViewModel {
    @Published var currentUser: User = User(userId: "", userName: "", fullName: "", phoneNo: "", password: "", PIN: "", userImage: "")
    @Published var fetchedImage: UIImage?
//    let activityIndicator = ActivityIndicator()
    let ref: DatabaseReference! = Database.database().reference()
    
    @Published var isLoading = false

    func saveUserDetails(){
        
        var uid : String
        if Auth.auth().currentUser == nil {
            uid = "test"
        } else {
            uid = Auth.auth().currentUser!.uid
        }
        
//        let uid = Auth.auth().currentUser!.uid
        do{
            if let profile = fetchedImage{
                currentUser.userImage = profile.toJpegString(compressionQuality: 0.2) ?? ""
            }
            let jsonData = try JSONEncoder().encode(currentUser)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("user").child(uid).setValue(SharedMethods().jsonToDictionary(from: jsonString))
        }catch{
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
            self.isLoading = true
        }

        userRef.observeSingleEvent(of: .value, with: { [self] snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    return
                }

            let userId = uid
            let userName = userData["userName"] as? String ?? ""
            let fullName = userData["fullName"] as? String ?? ""
            let phoneNo = userData["phoneNo"] as? String ?? ""
            let password = userData["password"] as? String ?? ""
            let PIN = userData["PIN"] as? String ?? ""
            let userImage = userData["userImage"] as? String ?? ""

            currentUser = User(userId: userId, userName: userName, fullName: fullName, phoneNo: phoneNo, password: password, PIN: PIN, userImage: userImage)
            })
        
            DispatchQueue.main.async{
                self.isLoading = false
            }
    }
}
