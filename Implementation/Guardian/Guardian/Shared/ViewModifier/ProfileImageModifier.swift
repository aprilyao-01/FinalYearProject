//
//  ProfileImageModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 26/02/2023.
//

import SwiftUI

struct ProfileImageModifier: ViewModifier {
    @StateObject var profileVM: ProfileVM = ProfileVM()
    @State var showingImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var fetchedImageName: String?
    
    var myWidth: CGFloat = 100
    var myHeight: CGFloat = 100
    
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                Button(action: {showingImagePicker.toggle()}, label: {
                    Image("pencil")
                        .resizable()
                        .foregroundColor(Color("main"))
                        .frame(width: myWidth/4, height: myHeight/4, alignment: .center)
                        .padding(.trailing, myWidth/10)
                })
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $profileVM.fetchedImage, sourceType: $sourceType, fileName: $fetchedImageName)
            }
    }
    
}

extension View {
    func withChangeOption() -> some View {
        self.modifier(ProfileImageModifier())
    }
}
