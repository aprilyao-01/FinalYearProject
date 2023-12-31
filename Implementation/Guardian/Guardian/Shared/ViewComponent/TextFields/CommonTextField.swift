//
//  CustomTextField.swift
//  Guardian
//
//  Created by Siyu Yao on 18/12/2023.
//

import SwiftUI

struct CommonTextField: View {
    var hint: String
    @Binding var text: String
    var isPassword : Bool = false
    var keyboardType: UIKeyboardType = .default
    var sfSymbol: String?
    
    // MARK: View Properties
    @FocusState var isEnabled: Bool
    var contentType: UITextContentType = .telephoneNumber
    var width: CGFloat = 300
    
    var body: some View {
        VStack(){
            if (isPassword) {
                SecureField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .focused($isEnabled)
                    .padding(.leading, sfSymbol == nil ? width/6 : width/6+40)
            }
            else {
                TextField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .focused($isEnabled)
                    .padding(.leading, sfSymbol == nil ? width/6 : width/6+40)
            }
            ZStack(){
                if let systemImage = sfSymbol {
                    Image(systemName: systemImage)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.bottom, 40)
                        .padding(.trailing, 260)
                }
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(width: width, height: 1)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: isEnabled ? width: 0, height: 1, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
            }
            .frame(height: 2)
        }
    }
}

struct CommonTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CommonTextField(hint: "Phone number",
                                text: .constant(""),
                                keyboardType: .default,
                                sfSymbol: "phone.fill")
            .preview(with: "Login and Register Text Input")
            
            CommonTextField(hint: "Some text",
                                text: .constant(""),
                                keyboardType: .default)
            .preview(with: "some text")
        }
    }
}
