//
//  ProfileBtnWithChevronRight.swift
//  Guardian
//
//  Created by Siyu Yao on 28/01/2023.
//

import SwiftUI

struct chevronRightBtn: View {
    var action: () -> Void
    var label: String
    
    var body: some View {
        Button(action: action, label: {
            HStack{
                Text(label)
                    .foregroundColor(Color.black)
                    .font(.system(size: 16))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 18))
                    .padding(.trailing, 10)

            }
        })
    }
}

struct ProfileBtnWithChevronRight_Previews: PreviewProvider {
    static var previews: some View {
        chevronRightBtn(action: {}, label: "action").preview(with: "Button with chevron in right")
    }
}
