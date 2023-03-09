//
//  Login.swift
//  Guardian
//
//  Created by Siyu Yao on 03/12/2023.
//

import SwiftUI
import AlertToast

struct LoginPhone: View {
    @StateObject var loginModel: LoginPhoneViewModel = .init()
    
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
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    )
                    .lineSpacing(5)
                    .padding(.top, -70)
                    .padding(.bottom, -10)
                    
                    HStack {
                        NavigationLink(destination: LoginEmail()){
                                Text("Email")
                                    .opacity(0.9)
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.system(size: 20))
                        }
                        
                        VStack(spacing: 0) {
                            Text("Phone")
                                .opacity(0.9)
                                .foregroundColor(Color("main"))
                                .font(.system(size: 20))
                            Rectangle()
                                .fill(Color("main"))
                                .frame(width: 60, height: 1)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: custom TextField
                    CommonTextField(hint: "+44 7468907383", text: $loginModel.phoneNo, keyboardType: .phonePad, sfSymbol: "phone.fill")
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
                    CommonTextField(hint: "OTP", text: $loginModel.otpCode, keyboardType: .numberPad, sfSymbol: "key.fill")
                        .disabled(!loginModel.showOTPField)
                        .opacity(!loginModel.showOTPField ? 0.4 : 1)
                        .padding(.bottom,20)

                    // MARK: get and verify OTP
                    CommonButton(
                        buttonName: loginModel.showOTPField ? "Verify Code" : "Get Code", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"),
                        width: 200,
                        action: loginModel.showOTPField ? loginModel.verifyOTP : loginModel.getOTP)
                    .padding(.top,5)
                }
                .alert(loginModel.errorMessage, isPresented: $loginModel.showError){}
                .toast(isPresenting: $loginModel.showToast){
                    
                    // `.alert` is the default displayMode
                    AlertToast(displayMode: .hud, type: .complete(.green), title: "Code Sent!")
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

struct LoginPhone_Previews: PreviewProvider {
    static var previews: some View {
        LoginPhone()
    }
}
