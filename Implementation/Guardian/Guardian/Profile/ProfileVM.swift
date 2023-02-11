//
//  ProfileVM.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol ProfileViewModel {
    var activityIndicator: ActivityIndicator { get }
    var currentuser: User { get }
    var fetchedImage: UIImage? { get }
    
    func saveUserDetails()
    func fetchCurrentUser()
    
}

class ProfileVM: ObservableObject, ProfileViewModel {
    @Published var currentuser: User = User(userId: SettingsStore.shared().currentUserId, userName: "", fullName: "", phoneNo: "", password: "", pin: SettingsStore.shared().appPIN, userImage: "")
    @Published var fetchedImage: UIImage?
    let activityIndicator = ActivityIndicator()
    let ref: DatabaseReference! = Database.database().reference()

    func saveUserDetails(){
        do{
            if let profile = fetchedImage{
                currentuser.userImage = profile.toJpegString(compressionQuality: 0.2) ?? ""
            }
            let jsonData = try JSONEncoder().encode(currentuser)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ref.child("user").child(currentuser.userId).setValue(SharedMethods().jsonToDictionary(from: jsonString))
        }catch{
            print("ProfileVM: cannot save user details\n %s", error)
        }
    }
    
    func fetchCurrentUser() {
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        
        _ = ref.observe(DataEventType.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let userList = value?["user"] as? NSDictionary
            let users = userList?[SettingsStore.shared().currentUserId] as? NSDictionary
            
            do {
                let json = try JSONSerialization.data(withJSONObject: users ?? [:])
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedUser = try decoder.decode(User.self, from: json)
                self.currentuser = decodedUser
                self.fetchedImage = self.currentuser.userImage.toImage()
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                }
            } catch {
                print("ProfileVM: cannot fetch user details\n %s", error)
            }
        })

    }
    
    
}
