//
//  ImageExtension.swift
//  Guardian
//
//  Created by Siyu Yao on 27/01/2023.
//

import SwiftUI

extension UIImage {
    func toPngString() -> String? {
        return self.pngData()?.base64EncodedString()
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
}


extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
