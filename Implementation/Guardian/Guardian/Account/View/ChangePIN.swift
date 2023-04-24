//
//  ChangePIN.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import SwiftUI

struct ChangePIN: View {
    @State var oldPIN: String = ""
    @State var newPIN: String = ""
    @State var confirmPIN: String = ""
    @StateObject var accountVM: AccountVM
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30){
                TextFieldWithHeading(label: "Old PIN", textFieldValue: $oldPIN, placeholder: "Enter old PIN", isLockButtonEnabled: true,isPasswordField: true)
                    .padding(.top,10)
                TextFieldWithHeading(label: "New PIN", textFieldValue: $newPIN, placeholder: "Enter new PIN", isLockButtonEnabled: true,isPasswordField: true)
                    .padding(.top,10)
                TextFieldWithHeading(label: "Confirm PIN", textFieldValue: $confirmPIN, placeholder: "Confirm PIN", isLockButtonEnabled: true,isPasswordField: true)
                    .padding(.top,10)
                  
                CommonButton(buttonName: "Confirm", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                    if oldPIN != "" && newPIN != "" && confirmPIN != ""{
                        if newPIN == confirmPIN{
                            accountVM.changePIN(oldPin: oldPIN, newPin: newPIN)
                        }else{
                            SharedMethods.showMessage("Error", message: "New PIN and the confirm PIN should be the same", onVC: UIApplication.topViewController())
                        }
                    }else{
                        SharedMethods.showMessage("Error", message: "Please fill all the fields", onVC: UIApplication.topViewController())
                    }
                })
                .padding(.top,30)
                Spacer()
            }
            .withNavBar(leftImg: "chevron.left", leftAction: {
                presentationMode.wrappedValue.dismiss()
            }, midTitle: "Change PIN", rightAction: {})
            .navigationBarBackButtonHidden(true)
            .onChange(of: accountVM.isUserPinChangeSuccess, perform: {newValue in
                if newValue{
                    SharedMethods.showMessageWithOKActionBtn("Success", message: "PIN changed successfully", OKMessage: "OK", onVC: UIApplication.topViewController(), proceedAction: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            })
        }
    }
}

struct ChangePIN_Previews: PreviewProvider {
    static var previews: some View {
        ChangePIN(accountVM: AccountVM())
    }
}
