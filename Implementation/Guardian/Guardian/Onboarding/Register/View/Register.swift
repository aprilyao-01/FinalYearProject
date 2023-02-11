//
//  Register.swift
//  Guardian
//
//  Created by Siyu Yao on 03/12/2023.
//

import SwiftUI

struct Register: View {
    
    // MARK: ViewModel StateObject
    @StateObject private var registerVM = RegisterVM(service: RegisterServiceImp1()
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
                    LRPageTextField(hint: "Full Name", text: $registerVM.userDetails.fullName, sfSymbol: "person.fill")
                    
                    LRPageTextField(hint: "Email", text: $registerVM.userDetails.email, sfSymbol: "envelope.fill")
                    
                    LRPageTextField(hint: "Password", text: $registerVM.userDetails.password, isPassword: true,  sfSymbol: "lock.fill")
                    
                    LRPageTextField(hint: "Phone number", text: $registerVM.userDetails.phoneNo, keyboardType: .phonePad, sfSymbol: "phone.fill")
                }
                Text("You'll receive a 4 digit code to verify next")
                    .padding(.top, 5)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                
                CommonButton(buttonName: "Sign up", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 200) {
                    registerVM.register()
                    // TODO: authentication
                    // TODO: goto createPIN
                }
//                Button {
//                } label: {
//                    Text("Get Code")
//                        .font(.system(size: 20, weight: .bold, design: .rounded))
//                        .frame(width: 200, height: 45)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                .fill(.linearGradient(colors: [Color.mainRed, Color.lightRed], startPoint: .topLeading, endPoint: .bottom)))
//                        .foregroundColor(.white)
//                }
                .padding(.top,5)
//                .offset(y:10)

                
                
                LRPageButton(isRed: false)
                .padding(.top,5)
//                .offset(y:10)
                
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
