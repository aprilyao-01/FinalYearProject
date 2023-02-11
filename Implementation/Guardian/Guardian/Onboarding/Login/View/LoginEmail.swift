//
//  LoginEmail.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import SwiftUI
import AlertToast

struct LoginEmail: View {
    @StateObject var loginModel: LoginViewModel = .init()
    @State private var email = ""
    @State private var password = ""
    @State private var showReset = false
    
    
    var body: some View {
            ZStack{
                // MARK: custom background
                LRPageBackground(isRed: false)

                VStack(spacing: 20){
                    LRPageButton(isRed: true)
                    .padding(.top, -70)
                    .padding(.bottom, 40)
                    
                    (Text("Welcome")
                        .foregroundColor(.black)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                     + Text ("\n Continue with...")
                        .foregroundColor(.gray)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    )
                    .lineSpacing(5)
                    .padding(.top, -70)
                    .padding(.bottom, -10)
                    
                    HStack {
                        VStack(spacing: 0) {
                            Text("Email")
                                .opacity(0.9)
                                .foregroundColor(Color("main"))
                                .font(.system(size: 20))
                            Rectangle()
                                .fill(Color("main"))
                                .frame(width: 50, height: 1)
                        }
                        
                        NavigationLink(destination: LoginPhone()){
                                Text("Phone")
                                    .opacity(0.9)
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.system(size: 20))
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: custom TextField
                    LRPageTextField(hint: "Email", text: $email, sfSymbol: "envelope.fill")
                        .disabled(loginModel.showOTPField)
                        .opacity(loginModel.showOTPField ? 0.4 : 1)
                        .overlay(alignment: .trailing, content: {
                            Button("Change"){
                                withAnimation(.easeInOut){
                                    loginModel.showOTPField = false
                                    loginModel.otpCode = ""
                                    loginModel.CLIENT_CODE = ""
                                }
                            }
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(Color("main"))
                            .opacity(loginModel.showOTPField ? 1 : 0)
                            .padding(.trailing, 50)
                        })

                    LRPageTextField(hint: "Password", text: $password, isPassword: true, sfSymbol: "lock.fill")
                    
                    CommonButton(buttonName: "Forget Password?", backgroundColor1: .clear, backgroundColor2: .clear, fontColor: Color("mainRed"), fontSize: 16, fontIsBold: false, width: 180){
                        showReset.toggle()
                    }
                    .sheet(isPresented: $showReset,
                           content: {
                        ResetPassword()
                    })
//                    .padding(.bottom,20)

                    // TODO: verifiy password
                    // MARK: get and verify OTP
                    CommonButton(
                        buttonName: loginModel.showOTPField ? "Verify Code" : "Get Code", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"),
                        width: 200,
                        action: loginModel.showOTPField ? loginModel.verifyOTP : loginModel.getOTP)
                    .padding(.top,5)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }



struct LoginEmail_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmail()
    }
}
