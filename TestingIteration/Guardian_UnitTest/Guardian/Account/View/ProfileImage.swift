//
//  ProfileImage.swift
//  Guardian
//
//  Created by Siyu Yao on 28/01/2023.
//

import SwiftUI

struct ProfileImage: View {
    @StateObject var accountVM: AccountVM = AccountVM()
    
    var myWidth: CGFloat = 100
    var myHeight: CGFloat = 100
    
    var body: some View {
        VStack{
            if accountVM.fetchedImage != nil {
                Image(uiImage: accountVM.fetchedImage!)
                    .resizable()
                    .frame(width: myWidth, height: myWidth)
                    .clipShape(Circle())
                  
            }else{
                Image(systemName: "person.crop.circle")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: myWidth, height: myHeight, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
            
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
            .preview(with: "Profile Image")
    }
}
