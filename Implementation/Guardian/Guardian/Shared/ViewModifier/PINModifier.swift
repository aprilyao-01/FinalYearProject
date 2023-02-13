//
//  PINModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 02/02/2023.
//

import SwiftUI

struct PINModifier: ViewModifier {
    @FocusState private var isFocus: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .font(.system(size: 25, design: .rounded))
            .frame(width: 60, height: 60, alignment: .center)
            .multilineTextAlignment(.center)
            .background(isFocus ? .gray.opacity(0.2) : .gray.opacity(0.5))
            .cornerRadius(10)
            .keyboardType(.numberPad)
            .focused($isFocus)
            .overlay(isFocus ? RoundedRectangle(cornerRadius: 10).stroke(Color("main"), lineWidth: 1) : nil)
            .animation(.easeInOut(duration: 0.2), value: isFocus)
    }
}

struct PINOnChangeModifier: ViewModifier {
    
    
    @Binding var thisPIN: String
    @FocusState var focusedField: Field?
    
    var thisFocusField: Field
    var nextFocusField: Field?
    var previousFocusField: Field = .field1

    var isFirstField: Bool = false
    
    func body(content: Content) -> some View {
        content
            .focused($focusedField, equals: thisFocusField)
            .onChange(of: thisPIN, perform: { val in
                if val == "" {
                    if !isFirstField {
                        focusedField = previousFocusField      // send focus backward
                    }
                } else {
                    thisPIN = String(val.prefix(1))  // maxlength limited to 1
                    focusedField = nextFocusField      // move focus to next field
                                                        //or nextFocusField == nil dismiss the keyboard
                }
            })
    }
}

extension View {
    func asPIN() -> some View {
        self.modifier(PINModifier())
    }
    
    func moveFocus(thisPIN: Binding<String>, focusedField: FocusState<Field?>, thisFocusField: Field, nextFocusField: Field?, previousFocusField: Field = .field1, isFirstField: Bool = false) -> some View {
        self.modifier(PINOnChangeModifier(thisPIN: thisPIN, focusedField: focusedField, thisFocusField: thisFocusField, nextFocusField: nextFocusField, previousFocusField: previousFocusField, isFirstField: isFirstField))
    }
}
