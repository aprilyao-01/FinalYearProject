//
//  ResetPassword.swift
//  Guardian
//
//  Created by Siyu Yao on 01/02/2023.
//

import SwiftUI
import AlertToast

struct ResetPassword: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = ResetPasswordVM(service: ResetPasswordService())
    
    var body: some View {
        NavigationView{
            ZStack{
                
                LRPageBackground(isRed: false, isFirst: true)
                (Text("Enter your email")
                    .foregroundColor(.black)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                 + Text ("\n to recive a reset link")
                    .foregroundColor(.gray)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                )
                .lineSpacing(5)
                .padding(.bottom, 400)
                
                LRPageTextField(hint: "Email", text: $vm.email, keyboardType: .emailAddress, sfSymbol: "envelope.fill")
                    .padding(.bottom, 150)
                CommonButton(buttonName: "Sent password reset", backgroundColor1: Color("main"), backgroundColor2: Color("lightRed"), width: 280, action: {
                    vm.sendPasswordReset()
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.top, 70)
            }
            
            //FIXME: make success toast and failed alert
            .toast(isPresenting: $vm.isSent, alert: {
                AlertToast(displayMode: .hud, type: .regular, title: "Reset link sent", subTitle: "Check your email inbox")
            })
            .alert(isPresented: $vm.hasError, content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong"))
                }
            })
//            .alert(isPresented: $vm.hasError, content: {
//                Alert(title: Text("Failed"), message: Text(vm.errorMessage))
//            })
            .navigationTitle("Reset Password")
            .applyClose()
        }
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
