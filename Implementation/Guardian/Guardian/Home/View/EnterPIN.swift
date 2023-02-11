//
//  EnterPIN.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import SwiftUI
import AlertToast

struct EnterPIN: View {
    
    // MARK: PIN numbers
    @State var pin1: String = ""
    @State var pin2: String = ""
    @State var pin3: String = ""
    @State var pin4: String = ""
    
    // MARK: 
    
    var body: some View {
        VStack(spacing: 40){
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color("mainRed"))
                .font(.system(size: 100))
                .padding(.top, 100)
            
            // TODO: contdown
            Text("Sending message to your emergency contacts in <> s")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
                .frame(alignment: .center)
            
            VStack (spacing: 20){
                PINTextField(pin1: $pin1, pin2: $pin2, pin3: $pin3, pin4: $pin4)
                    .padding(.top, 10)
                
                // TODO: contdown
                Text("Enter your PIN to cancel,\n  you still have <> times")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black.opacity(0.7))
            }
            
            
           
            Spacer()
            
            CommonButton(buttonName: "Confirm Cancel", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                // TODO:
            })
            .padding(.bottom, 100)
        }
    }
}

struct EnterPIN_Previews: PreviewProvider {
    static var previews: some View {
        EnterPIN()
    }
}
