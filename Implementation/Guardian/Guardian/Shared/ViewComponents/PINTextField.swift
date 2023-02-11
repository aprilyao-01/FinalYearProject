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
//                .focused($focusedField, equals: .field1)
//                .onChange(of: pin1, perform: { val in
//                    if val == "" {
//
//                    } else {
//                        pin1 = String(val.prefix(1))  // maxlength limited to 1
//                        focusedField = .field2      // move focus to next field
//                    }
//                })
                
            TextField("", text: $pin2)
                .asPIN()
                .moveFocus(thisPIN: $pin2, focusedField: _focusedField, thisFocusField: .field2, nextFocusField: .field3, previousFocusField: .field1)
//                .focused($focusedField, equals: .field2)
//                .onChange(of: pin2, perform: { val in
//                    if val == "" {
//                        focusedField = .field1      // send focus backward
//                    } else {
//                        pin2 = String(val.prefix(1))  // maxlength limited to 1
//                        focusedField = .field3      // move focus to next field
//                    }
//                })
            
            TextField("", text: $pin3)
                .asPIN()
                .moveFocus(thisPIN: $pin3, focusedField: _focusedField, thisFocusField: .field3, nextFocusField: .field4, previousFocusField: .field2)
//                .focused($focusedField, equals: .field3)
//                .onChange(of: pin3, perform: { val in
//                    if val == "" {
//                        focusedField = .field2      // send focus backward
//                    } else {
//                        pin2 = String(val.prefix(1))  // maxlength limited to 1
//                        focusedField = .field4      // move focus to next field
//                    }
//                })
            TextField("", text: $pin4)
                .asPIN()
                .moveFocus(thisPIN: $pin4, focusedField: _focusedField, thisFocusField: .field4, nextFocusField: nil, previousFocusField: .field3)
//                .focused($focusedField, equals: .field4)
//                .onChange(of: pin4, perform: { val in
//                    if val == "" {
//                        focusedField = .field1      // send focus backward
//                    } else {
//                        pin2 = String(val.prefix(1))  // maxlength limited to 1
//                        focusedField = .field3      // move focus to next field
//                    }
//                })
        }
//        .toast(isPresenting: $show, alert: {
//            AlertToast(type: .loading, title: "Loading")
//        })
    }
}


struct PINTextField_Previews: PreviewProvider {
    static var previews: some View {
        PINTextField(pin1: .constant("2"), pin2: .constant("0"), pin3: .constant("2"), pin4: .constant("3"))
            .preview(with: "4 digits PIN")
    }
}
