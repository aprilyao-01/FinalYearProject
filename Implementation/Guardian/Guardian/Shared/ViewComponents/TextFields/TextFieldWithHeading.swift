//
//  TextFieldWithHeading.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import SwiftUI

struct TextFieldWithHeading: View {
    var label: String
    @Binding var textFieldValue: String
    var placeholder: String
    var isLockButtonEnabled: Bool
    var isPasswordField: Bool
    @State var isEnabled: Bool = true

    var body: some View {
        VStack(alignment: .leading){
            Text(label)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
            DefaultTextLabel(textValue: $textFieldValue, placeHolder: placeholder,isEnabled: isEnabled, isLockButtonEnabled: isLockButtonEnabled, isPasswordField: isPasswordField)
        }
    }
}

struct TextFieldWithHeading_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithHeading(label: "sample", textFieldValue: .constant("this is sample"), placeholder: "this is plaveholder", isLockButtonEnabled: false, isPasswordField: false)
            .preview(with: "profile page field with text heading")
    }
}
