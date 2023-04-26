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
    @State var showChangePasswordView: Bool = false
    @State var showChangePINView: Bool = false
    @State var showAudioManageView: Bool = false
    @StateObject var accountVM: AccountVM = AccountVM()
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView{
                    VStack{
                        ProfileImage(accountVM: accountVM)
                            .withChangeOption(accountVM: accountVM)
                        
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
                NavigationLink ("", destination: AudioManage(), isActive: $showAudioManageView)
            }
            //MARK: full screen - change password
            .fullScreenCover(isPresented: $showChangePasswordView, content: {
                ChangePassword(accountVM: accountVM)
            })
            //MARK: full screen - change pin
            .fullScreenCover(isPresented: $showChangePINView, content: {
                ChangePIN(accountVM: accountVM)
            })
            .navigationBarItems(trailing: Button(action: {
                accountVM.saveUserDetails(completion: {_ in })
            }, label: {Text("Save")}))
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear(){
            accountVM.fetchCurrentUser(completion: {_ in })
        }
    }
}

struct UserAccount_Previews: PreviewProvider {
    static var previews: some View {
        UserAccount().environmentObject(SessionServiceImpl(authSignOut: FirebaseAuthWrapper()))
    }
}
