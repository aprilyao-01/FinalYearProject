//
//  DefaultTextLabel.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import SwiftUI

struct DefaultTextLabel: View {
    @Binding var textValue:String
    var placeHolder: String
    var keyboardType = UIKeyboardType.default
    @State var isEnabled: Bool
    var isLockButtonEnabled: Bool
    var isPasswordField: Bool
    
    var body: some View {
        ZStack{
            if isPasswordField{
                SecureField(placeHolder, text: $textValue)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .foregroundColor(Color.black)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .disabled(!isEnabled)
            }else{
                TextField(placeHolder, text: $textValue)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .foregroundColor(Color.black)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .disabled(!isEnabled)
                
            }

            if isLockButtonEnabled{
                HStack{
                    Spacer()
                    if isEnabled{
                        Image(systemName: "checkmark")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.green)
                            .frame(width: 20,height: 20)
                            .onTapGesture {
                                isEnabled.toggle()
                            }
                            .padding(.trailing,10)
                    }else{
                        Image(systemName: "pencil")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .frame(width: 15,height: 20)
                            .onTapGesture {
                                isEnabled.toggle()
                            }
                            .padding(.trailing,10)

                    }
                }
            }
          
        }
    }
}

struct DefaultTextLabel_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTextLabel(textValue: .constant("test name"), placeHolder: "this is test", isEnabled: true, isLockButtonEnabled: true, isPasswordField: false)
            .preview(with: "Text label in profile")
    }
}
