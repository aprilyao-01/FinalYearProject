//
//  PINTextField.swift
//  Guardian
//
//  Created by Siyu Yao on 04/01/2023.
//

import SwiftUI


enum Field: Hashable {
    case field1
    case field2
    case field3
    case field4
}

struct PINTextField: View {
    @Binding var pin1: String
    @Binding var pin2: String
    @Binding var pin3: String
    @Binding var pin4: String
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        HStack(spacing: 15){
            TextField("", text: $pin1)
                .asPIN()
                .moveFocus(thisPIN: $pin1, focusedField: _focusedField, thisFocusField: .field1, nextFocusField: .field2, isFirstField: true)
                
            TextField("", text: $pin2)
                .asPIN()
                .moveFocus(thisPIN: $pin2, focusedField: _focusedField, thisFocusField: .field2, nextFocusField: .field3, previousFocusField: .field1)
            TextField("", text: $pin3)
                .asPIN()
                .moveFocus(thisPIN: $pin3, focusedField: _focusedField, thisFocusField: .field3, nextFocusField: .field4, previousFocusField: .field2)
            TextField("", text: $pin4)
                .asPIN()
                .moveFocus(thisPIN: $pin4, focusedField: _focusedField, thisFocusField: .field4, nextFocusField: nil, previousFocusField: .field3)
        }
        .onAppear {
            focusedField = .field1 // Set the initial focus to .field1
        }
    }
}


struct PINTextField_Previews: PreviewProvider {
    static var previews: some View {
        PINTextField(pin1: .constant("2"), pin2: .constant("0"), pin3: .constant("2"), pin4: .constant("3"))
            .preview(with: "4 digits PIN")
    }
}
