//
//  ProfileImageModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 26/02/2023.
//

import SwiftUI

struct ProfileImageModifier: ViewModifier {
    @StateObject var profileVM: AccountVM
    @State var showingImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var fetchedImageName: String?
    
    var myWidth: CGFloat = 100
    var myHeight: CGFloat = 100
    
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    showingImagePicker.toggle()
                    profileVM.isProfilePictureChanged.toggle()
                }, label: {
                    Image("pencil")
                        .resizable()
                        .foregroundColor(Color("main"))
                        .frame(width: myWidth/4, height: myHeight/4, alignment: .center)
                        .padding(.trailing, myWidth/10)
                })
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $profileVM.fetchedImage, sourceType: $sourceType, fileName: $fetchedImageName, showingImagePicker: $showingImagePicker)
            }
    }
    
}

extension View {
    func withChangeOption(accountVM: AccountVM) -> some View {
        self.modifier(ProfileImageModifier(profileVM: accountVM))
    }
}
