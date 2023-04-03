//
//  ImageExtensionTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 03/04/2023.
//

import XCTest
import UIKit

@testable import Guardian

final class ImageStringConversionTests: XCTestCase {
    
    var originalImage: UIImage!
        
        override func setUp() {
            super.setUp()
            originalImage = UIImage(named: "testImage")!
        }
        
        override func tearDown() {
            originalImage = nil
            super.tearDown()
        }
    
    func testImageToPngString() {
        let pngString = originalImage.toPngString()
        XCTAssertNotNil(pngString)
    }
    
    func testImageToJpegString() {
        let jpegString = originalImage.toJpegString(compressionQuality: 1.0)
        XCTAssertNotNil(jpegString)
    }
    
    func testStringToImage() {
        let pngString = originalImage.toPngString()
        let convertedImage = pngString?.toImage()
        
        XCTAssertNotNil(convertedImage)
    }
}
