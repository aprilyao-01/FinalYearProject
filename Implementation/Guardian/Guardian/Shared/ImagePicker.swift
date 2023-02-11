//
//  ImagePicker.swift
//  Guardian
//
//  Created by Siyu Yao on 27/01/2023.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var fileName: String?
    
    func makeCoordinator() -> UIImagePickerCoordinator {
        return UIImagePickerCoordinator(self, image: $image, fileName: $fileName)
    }
    
    // MARK: make and update controllers
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}


class UIImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    private let parent: ImagePicker
    @Binding var fileName: String?

    init(_ parent: ImagePicker, image: Binding<UIImage?>,fileName: Binding<String?>) {
        self._image = image
        self.parent = parent
        self._fileName = fileName
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = cropImageToSquare(image: uiImage)
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                fileName = url.lastPathComponent
        }else{
            if self.parent.sourceType == .camera {
                fileName = "DSC-" + UUID().uuidString
            }
        }
        parent.presentationMode.wrappedValue.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.presentationMode.wrappedValue.dismiss()
    }

    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }

        return nil
    }
}
