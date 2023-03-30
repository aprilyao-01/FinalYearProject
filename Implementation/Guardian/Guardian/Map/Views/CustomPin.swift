//
//  CustomPin.swift
//  Guardian
//
//  Created by Siyu Yao on 09/02/2023.
//

import MapKit
import SwiftUI

struct CustomPin: View {
    
    @Binding var pinImg: String
    var color: Color
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(systemName: pinImg)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: width, height: height)
    }
}

struct CustomPin_Previews: PreviewProvider {
    static var previews: some View {
        CustomPin(pinImg: .constant(""), color: .white, width: 40, height: 40)
    }
}

