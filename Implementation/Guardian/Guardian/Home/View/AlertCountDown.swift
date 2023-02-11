//
//  AlertCancel.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import SwiftUI

struct AlertCountDown: View {
    // MARK: view propoties
    //@StateObject var contactVM: ContactVM
    
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
            Spacer()
            CommonButton(buttonName: "Cancel", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                // TODO: Cancel -> to enter PIN
            })
            .padding(.bottom, 100)
            
            
        }
    }
}

struct AlertCancel_Previews: PreviewProvider {
    static var previews: some View {
        AlertCountDown()
    }
}
