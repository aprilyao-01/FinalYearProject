//
//  UserAccount.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import SwiftUI

struct UserAccount: View {
    @EnvironmentObject var service: SessionServiceImpl
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showingImagePicker: Bool = false
    @State var fetchedImageName: String?
//    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var showChangePasswordView: Bool = false
    @State var showChangePINView: Bool = false
    @State var showAudioManageView: Bool = false
    @StateObject var accountVM: AccountVM = AccountVM()
    
    
    var body: some View {
        VStack {
            if accountVM.isLoading {
                Loading()
            }
            else {
                ScrollView{
                    VStack{
                        ProfileImage(accountVM: accountVM)
                            .withChangeOption()
                        
                        // MARK: User detail
                        VStack(spacing: 20){
                            TextFieldWithHeading(label: "Username", textFieldValue: $accountVM.currentUser.userName, placeholder: "Enter username", isLockButtonEnabled: true, isPasswordField: false)
                            
                            TextFieldWithHeading(label: "Full Name", textFieldValue: $accountVM.currentUser.fullName, placeholder: "Enter Full Name", isLockButtonEnabled: true, isPasswordField: false)
                            
                            TextFieldWithHeading(label: "Contact Details", textFieldValue: $accountVM.currentUser.phoneNo, placeholder: "Enter phone number", isLockButtonEnabled: true, isPasswordField: false)
                            
                            chevronRightBtn(action: {
                                showChangePasswordView.toggle()
                            }, label: "Change Password")
                                .padding(.top,25)

                            chevronRightBtn(action: {
                                showChangePINView.toggle()
                            }, label: "Change PIN")
                                .padding(.top,20)
                            
                            chevronRightBtn(action: {
                                showAudioManageView.toggle()
                            }, label: "Audio Manage")
                                .padding(.top,20)
                        }
                        .padding(.horizontal, 5)
                        
                        // MARK: logout and delete account
                        CommonButton(buttonName: "Log Out", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 300, action: {service.logout()})
                            .padding(.top, 50)
                        
                        CommonButton(buttonName: "Delete account", backgroundColor1: .clear, backgroundColor2: .clear, fontColor: Color("mainRed"), width: 300, action: {
                            accountVM.deleteCurrentUser()
                        })
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                }
                
                // MARK: navigation links
                NavigationLink ("", destination: ChangePassword(), isActive: $showChangePasswordView)
                NavigationLink ("", destination: ChangePIN(), isActive: $showChangePINView)
                NavigationLink ("", destination: AudioManage(), isActive: $showAudioManageView)
            }
        }
        .withNavBar(leftImg: "chevron.left", leftAction: {
            presentationMode.wrappedValue.dismiss()
        }, midTitle: "Profile", rightAction: {})
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            accountVM.fetchCurrentUser()
        }
    }
}

struct UserAccount_Previews: PreviewProvider {
    static var previews: some View {
        UserAccount().environmentObject(SessionServiceImpl())
    }
}
