//
//  MapPinModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 09/02/2023.
//

import MapKit
import SwiftUI

struct CustomPin: View {
    
    var pinImg: String
    var color: Color
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(systemName: pinImg)
        .foregroundColor(color)
        .frame(width: 40, height: 40)
    }
}

extension MKPointAnnotation {
    static func createAnnotationView(pinImg: String? = "mappin.and.ellipse",
                                      pinColor: Color? = Color("mainRed"),
                                      width: CGFloat? = 20,
                                      height: CGFloat? = 20) -> some View {
        CustomPin(pinImg: pinImg ?? "mappin.and.ellipse",
                  color: pinColor ?? Color("mainRed"),
                  width: width ?? 20,
                  height: height ?? 20)
    }
}

