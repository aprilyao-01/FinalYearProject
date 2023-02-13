//
//  Register.swift
//  Guardian
//
//  Created by Siyu Yao on 03/12/2023.
//

import SwiftUI

struct Register: View {
    
    // MARK: ViewModel StateObject
    @StateObject private var registerVM = RegisterVM(service: RegisterServiceImpl()
    )
    
    var body: some View {
        ZStack{
            // MARK: custom background
            LRPageBackground(isRed: true)
            
            VStack(spacing: 25){
                Text("Register")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .padding(.bottom, 15)
//                    .offset(y: -30)
                
                // MARK: user info list
                VStack(spacing: 20) {
                    LRPageTextField(hint: "User Name", text: $registerVM.userDetails.userName, sfSymbol: "person.fill")
                    
                    LRPageTextField(hint: "Email", text: $registerVM.userDetails.email, sfSymbol: "envelope.fill")
                    
                    LRPageTextField(hint: "Password", text: $registerVM.userDetails.password, isPassword: true,  sfSymbol: "lock.fill")
                    
//                    LRPageTextField(hint: "Phone number", text: $registerVM.userDetails.phoneNo, keyboardType: .phonePad, sfSymbol: "phone.fill")
                }
//                Text("You'll receive a 4 digit code to verify next")
//                    .padding(.top, 5)
//                    .foregroundColor(.gray)
//                    .opacity(0.8)
                
                CommonButton(buttonName: "Sign up", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 200) {
                    registerVM.register()
                }
                .padding(.top,5)

                
                
                LRPageButton(isRed: false)
                .padding(.top,5)
                
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $registerVM.hasError, content: {
            if case .failed(let error) = registerVM.state {
                return Alert(title: Text("Error"), message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"), message: Text("Something went wrong"))
            }
        })
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
