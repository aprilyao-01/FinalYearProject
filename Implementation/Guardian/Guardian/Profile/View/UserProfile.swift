//
//  UserProfile.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import SwiftUI

struct UserProfile: View {
    @EnvironmentObject var service: SessionServiceImpl
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showingImagePicker: Bool = false
    @State var fetchedImageName: String?
//    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var showChangePasswordView: Bool = false
    @State var showChangePINView: Bool = false
    @StateObject var profileVM: ProfileVM = ProfileVM()
    
    
    var body: some View {
        VStack {
            if profileVM.isLoading {
                Loading()
            }
            else {
                ScrollView{
                    VStack{
                        ProfileImage(profileVM: profileVM)
                            .withChangeOption()
                        
                        VStack(spacing: 20){
                            TextFieldWithHeading(label: "Username", textFieldValue: $profileVM.currentUser.userName, placeholder: "Enter username", isLockButtonEnabled: true, isPasswordField: false)
                            
                            TextFieldWithHeading(label: "Full Name", textFieldValue: $profileVM.currentUser.fullName, placeholder: "Enter Full Name", isLockButtonEnabled: true, isPasswordField: false)
                            
                            TextFieldWithHeading(label: "Contact Details", textFieldValue: $profileVM.currentUser.phoneNo, placeholder: "Enter phone number", isLockButtonEnabled: true, isPasswordField: false)
                            
                            chevronRightBtn(action: {
                                showChangePasswordView.toggle()
                            }, label: "Change Password")
                                .padding(.top,25)

                            chevronRightBtn(action: {
                                showChangePINView.toggle()
                            }, label: "Change PIN")
                                .padding(.top,20)
                        }
                        
                        CommonButton(buttonName: "Logout", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 300, action: {service.logout()})
                            .padding(.top, 30)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                }
                // MARK: navigation to change PIN and password
                NavigationLink ("", destination: ChangePassword(), isActive: $showChangePasswordView)
                NavigationLink ("", destination: ChangePIN(), isActive: $showChangePINView)
            }
        }
        .withNavBar(leftImg: "chevron.left", leftAction: {
            presentationMode.wrappedValue.dismiss()
        }, midTitle: "Profile", rightAction: {})
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            profileVM.fetchCurrentUser()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile().environmentObject(SessionServiceImpl())
    }
}
