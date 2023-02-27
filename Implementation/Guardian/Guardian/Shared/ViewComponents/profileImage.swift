//
//  contactListView.swift
//  Guardian
//
//  Created by Siyu Yao on 28/01/2023.
//

import SwiftUI

struct profileImage: View {
    @StateObject var profileVM: ProfileVM = ProfileVM()
//    @State var showingImagePicker: Bool = false
//    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
//    @State var fetchedImageName: String?
    
    var myWidth: CGFloat = 100
    var myHeight: CGFloat = 100
    
    var body: some View {
        VStack{
            if profileVM.fetchedImage != nil {
                Image(uiImage: profileVM.fetchedImage!)
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
//        .overlay(alignment: .bottomTrailing) {
//            Button(action: {showingImagePicker.toggle()}, label: {
//                Image("pencil")
//                    .resizable()
//                    .foregroundColor(Color("main"))
//                    .frame(width: myWidth/4, height: myHeight/4, alignment: .center)
//                    .padding(.trailing, myWidth/10)
//            })
//        }
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(image: $profileVM.fetchedImage, sourceType: $sourceType, fileName: $fetchedImageName)
//        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        profileImage()
            .preview(with: "Profile Image")
    }
}
