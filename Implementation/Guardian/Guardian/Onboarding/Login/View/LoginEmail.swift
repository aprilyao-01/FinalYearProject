//
//  LoginEmail.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import SwiftUI
import AlertToast

struct LoginEmail: View {
    @StateObject var vm =  LoginEmailVM(service: LoginServiceImpl())
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
                        //MARK: discarded phone login since Feb.
//                        NavigationLink(destination: LoginPhone()){
//                                Text("Phone")
//                                    .opacity(0.9)
//                                    .foregroundColor(.gray.opacity(0.5))
//                                    .font(.system(size: 20))
//                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: custom TextField
                    CommonTextField(hint: "Email", text: $vm.credentials.email, sfSymbol: "envelope.fill")

                    CommonTextField(hint: "Password", text: $vm.credentials.password, isPassword: true, sfSymbol: "lock.fill")
                    
                    CommonButton(buttonName: "Forget Password?", backgroundColor1: .clear, backgroundColor2: .clear, fontColor: Color("mainRed"), fontSize: 16, fontIsBold: false, width: 180){
                        showReset.toggle()
                    }
                    .sheet(isPresented: $showReset,
                           content: {
                        ResetPassword()
                    })
                    CommonButton(
                        buttonName: "Login", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"),
                        width: 200,
                        action: {
                            vm.login()
                        })
                    .padding(.top,5)
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $vm.hasError, content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong"))
                }
            })
        }
    }



struct LoginEmail_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmail()
    }
}
