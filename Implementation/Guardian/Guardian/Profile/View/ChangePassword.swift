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
    
    var body: some View {
        VStack(spacing: 30){
            titleNavBar(title: "Change Password")
            TextFieldWithHeading(label: "Old Password", textFieldValue: $oldPassword, placeholder: "Enter old password", isLockButtonEnabled: false, isPasswordField: true)
                .padding(.top,10)
            TextFieldWithHeading(label: "New Password", textFieldValue: $newPassword, placeholder: "Enter new password", isLockButtonEnabled: false,isPasswordField: true)
                .padding(.top,10)
            TextFieldWithHeading(label: "Confirm Password", textFieldValue: $confirmPassword, placeholder: "Confirm password", isLockButtonEnabled: false,isPasswordField: true)
                .padding(.top,10)
            
            CommonButton(buttonName: "Confirm", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                // TODO: confirm change password
            })
            Spacer()
        }
        .navigationBarHidden(true)

    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}
