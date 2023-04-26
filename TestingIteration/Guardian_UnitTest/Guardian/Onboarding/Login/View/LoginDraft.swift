//
//  LoginDraft.swift
//  Guardian
//
//  Created by Siyu Yao on 28/11/2023.
//

import SwiftUI

struct LoginDraft: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongName: Float = 0
    @State private var wrongPassword: Float = 0
    
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color("main")
                    .ignoresSafeArea()
                Circle()
                    .scale(1.95)
                    .foregroundColor(.white.opacity(0.4))
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white)
                
                VStack{
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("UserName", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .border(.red, width: CGFloat(wrongName))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login"){
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color("main"))
                    .cornerRadius(8)
                }
            }
        }.navigationBarHidden(true)
    }
}

struct LoginDraft_Previews: PreviewProvider {
    static var previews: some View {
        LoginDraft()
    }
}
