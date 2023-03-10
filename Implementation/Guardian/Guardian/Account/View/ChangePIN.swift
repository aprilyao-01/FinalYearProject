//
//  ChangePIN.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import SwiftUI

struct ChangePIN: View {
    @State var oldPIN: String = ""
    @State var newPIN: String = ""
    @State var confirmPIN: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 30){
//            titleNavBar(title: "Change PIN")
            TextFieldWithHeading(label: "Old PIN", textFieldValue: $oldPIN, placeholder: "Enter old PIN", isLockButtonEnabled: false,isPasswordField: true)
                .padding(.top,10)
            TextFieldWithHeading(label: "New PIN", textFieldValue: $newPIN, placeholder: "Enter new PIN", isLockButtonEnabled: false,isPasswordField: true)
                .padding(.top,10)
            TextFieldWithHeading(label: "Confirm PIN", textFieldValue: $confirmPIN, placeholder: "Confirm PIN", isLockButtonEnabled: false,isPasswordField: true)
                .padding(.top,10)
              
            CommonButton(buttonName: "Confirm", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                // TODO: confirm change PIN
            })
            .padding(.top,30)
            Spacer()
        }
        .withNavBar(leftImg: "chevron.left", leftAction: {
            presentationMode.wrappedValue.dismiss()
        }, midTitle: "Change PIN", rightAction: {})
        .navigationBarBackButtonHidden(true)

    }
}

struct ChangePIN_Previews: PreviewProvider {
    static var previews: some View {
        ChangePIN()
    }
}
