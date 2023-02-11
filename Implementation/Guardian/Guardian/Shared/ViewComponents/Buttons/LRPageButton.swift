//
//  CustomButton.swift
//  Guardian
//
//  Created by Siyu Yao on 19/12/2023.
//

import SwiftUI

struct LRPageButton: View {
//    var text: String
    var isRed: Bool
    
    var body: some View {
        VStack{
            if (isRed){
                Text("New to here?")
                    .padding(.leading, 260)
                    .padding(.bottom, 80)
//                    .offset(x: 130, y:-80)
            } else {
                Text("Already have an account?")
//                    .offset(x: -105, y:25)
                    .padding(.trailing, 185)
                    .padding(.bottom, -20)
            }
            
            
            NavigationLink(destination: isRed ? AnyView(Register()) : AnyView(LoginEmail())){
                isRed ? nil : Image(systemName: "line.diagonal.arrow")
                    .rotationEffect(.init(degrees: 225))
                Text(isRed ? "Register" : "Login")
                isRed ? Image(systemName: "line.diagonal.arrow")
                    .rotationEffect(.init(degrees: 45)) : nil
            }
//            .offset(x: isRed ? 130 : -135, y: isRed ? -65 : 40)
            .padding(.leading, isRed ? 270 : -185)
            .padding(.top, isRed ? -75 : 30)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .overlay(
                ZStack {
                    Capsule()
                        .stroke(isRed ? Color("mainRed") : Color("main"), lineWidth: 3)
                        .frame(width: 200, height: 45)

                        .shadow(color: isRed ? Color("lightMain") : Color("lightRed"), radius: 10)
                        .cornerRadius(40)
//                        .offset(x: isRed ? 150 : -170, y: isRed ? -65 : 40)
                        .padding(.leading, isRed ? 300 : -270)
                        .padding(.top, isRed ? -85 : 30)
                }
            )
            
        }
        .foregroundColor(isRed ? Color("mainRed") : Color("main"))
       
    }
}

struct LRPageButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LRPageButton(isRed: true)
                .preview(with: "Go to Register")
            LRPageButton(isRed: false)
                .preview(with: "Go to Login")
        }
    }
}
