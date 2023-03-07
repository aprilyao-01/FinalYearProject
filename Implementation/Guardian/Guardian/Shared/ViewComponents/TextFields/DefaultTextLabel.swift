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
    @FocusState var current: Bool
    var isImgEnabled: Bool
    var isPasswordField: Bool
    
    var body: some View {
        ZStack{
            if isImgEnabled{
                HStack{
                    if isPasswordField{
                        SecureField(placeHolder, text: $textValue)
                            .keyboardType(keyboardType)
                            .padding(.horizontal)
                            .padding(.leading, 12)
                            .foregroundColor(Color.black)
                            .focused($current)
                            .disabled(isEnabled)
                    }else{
                        TextField(placeHolder, text: $textValue)
                            .keyboardType(keyboardType)
                            .padding(.horizontal)
                            .padding(.leading, 12)
                            .foregroundColor(Color.black)
                            .focused($current)
                            .disabled(isEnabled)
                        
                    }
                    Spacer()
                    if !isEnabled{
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.green)
                            .frame(width: 20,height: 20)
                            .onTapGesture {
                                isEnabled.toggle()
                            }
                            .padding(.trailing,40)
                    }else{
                        Image(systemName: "pencil")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .frame(width: 15,height: 20)
                            .onTapGesture {
                                isEnabled.toggle()
                            }
                            .padding(.trailing,40)

                    }
                }
            }
            Rectangle()
                .fill(.black.opacity(0.2))
                .frame(width: 330, height: 1)
                .padding(.top, 50)
            
            Rectangle()
                .fill(.black)
                .frame(width: !isEnabled ? 330: 0, height: 1, alignment: .leading)
                .animation(.easeInOut(duration: 0.3), value: isEnabled)
                .padding(.top, 50)
        }
    }
}

struct DefaultTextLabel_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTextLabel(textValue: .constant("test name"), placeHolder: "this is test", isEnabled: true, isImgEnabled: true, isPasswordField: false)
            .preview(with: "Text label in profile")
    }
}
