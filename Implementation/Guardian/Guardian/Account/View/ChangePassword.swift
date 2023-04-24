//
//  ChangePassword.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import SwiftUI

struct ChangePassword: View {
    @State var oldPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    @StateObject var accountVM: AccountVM
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30){
                TextFieldWithHeading(label: "Old Password", textFieldValue: $oldPassword, placeholder: "Enter old password", isLockButtonEnabled: true, isPasswordField: true)
                    .padding(.top,10)
                TextFieldWithHeading(label: "New Password", textFieldValue: $newPassword, placeholder: "Enter new password", isLockButtonEnabled: true,isPasswordField: true)
                    .padding(.top,10)
                TextFieldWithHeading(label: "Confirm Password", textFieldValue: $confirmPassword, placeholder: "Confirm password", isLockButtonEnabled: true,isPasswordField: true)
                    .padding(.top,10)
                
                CommonButton(buttonName: "Confirm", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                    if newPassword != "" && confirmPassword != "" && oldPassword != ""{
                        if newPassword == confirmPassword{
                            accountVM.changePassword(oldPassword: oldPassword, newPassword: newPassword)
                        }else{
                            SharedMethods.showMessage("Error", message: "New password is different from the confirm password", onVC: UIApplication.topViewController())
                        }
                    }else{
                        SharedMethods.showMessage("Error", message: "Please fill all the fields", onVC: UIApplication.topViewController())
                    }
                })
                .padding(.top, 30)
                Spacer()
            }
            .withNavBar(leftImg: "chevron.left", leftAction: {
                presentationMode.wrappedValue.dismiss()
            }, midTitle: "Change Password", rightAction: {})
            .navigationBarBackButtonHidden(true)
            .onChange(of: accountVM.isUserPasswordChangeSuccess, perform: {newValue in
                if newValue{
                    SharedMethods.showMessageWithOKActionBtn("Success", message: "User password changed successfully", OKMessage: "OK", onVC: UIApplication.topViewController(), proceedAction: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            })
        }
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword(accountVM: AccountVM())
    }
}
