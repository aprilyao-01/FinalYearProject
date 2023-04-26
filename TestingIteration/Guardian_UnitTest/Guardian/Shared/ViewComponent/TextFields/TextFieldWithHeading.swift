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
        VStack(alignment: .leading, spacing: 5){
            Text(label)
                .foregroundColor(Color.black)
            DefaultTextLabel(textValue: $textFieldValue, placeHolder: placeholder,isEnabled: isEnabled, isImgEnabled: isLockButtonEnabled, isPasswordField: isPasswordField)
        }
    }
}

struct TextFieldWithHeading_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithHeading(label: "sample", textFieldValue: .constant("sample"), placeholder: "this is plaveholder", isLockButtonEnabled: false, isPasswordField: false)
            .preview(with: "profile page field with text heading")
    }
}
