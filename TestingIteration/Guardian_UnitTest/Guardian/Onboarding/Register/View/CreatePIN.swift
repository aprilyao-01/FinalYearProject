//
//  CreatePIN.swift
//  Guardian
//
//  Created by Siyu Yao on 18/12/2023.
//

import SwiftUI

struct CreatePIN: View {
    
    // MARK: PIN numbers
    @State var p1: String = ""
    @State var p2: String = ""
    @State var p3: String = ""
    @State var p4: String = ""
    
    @StateObject var registerVM: RegisterVM
    
    var body: some View {
        VStack (spacing: 30){
            Spacer()
            Text("Set your PIN")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            
            Text("You will need to use this to cancel emergence")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            
            PINTextField(pin1: $p1, pin2: $p2, pin3: $p3, pin4: $p4)
                .padding(.top, 30)
            Spacer()
            CommonButton(buttonName: "Continue", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 200) {
                // TODO:
                registerVM.userDetails.PIN = p1+p2+p3+p4
                print(registerVM.userDetails.PIN)
                registerVM.register()
            }
            .padding(.top,30)
            
            Spacer()
        }
        
    }
}

struct CreatePIN_Previews: PreviewProvider {
    static var previews: some View {
        CreatePIN(registerVM: RegisterVM(service: RegisterServiceImpl()))
    }
}
