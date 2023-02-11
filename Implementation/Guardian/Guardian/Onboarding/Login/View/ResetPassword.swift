//
//  ResetPassword.swift
//  Guardian
//
//  Created by Siyu Yao on 01/02/2023.
//

import SwiftUI

struct ResetPassword: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                    LRPageBackground(isRed: false, isFirst: true)
                    // TODO: reset password components
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Reset Password")
                .applyClose()
        }
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
