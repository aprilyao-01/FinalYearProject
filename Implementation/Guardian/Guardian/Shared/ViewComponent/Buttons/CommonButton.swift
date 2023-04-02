//
//  CommonButton.swift
//  Guardian
//
//  Created by Siyu Yao on 24/01/2023.
//

import SwiftUI

struct CommonButton: View {
    
    var buttonName: String
    var backgroundColour1: Color
    var backgroundColour2: Color
    var fontColor: Color
    var fontSize: CGFloat
    var fontIsBold: Bool
    var width: CGFloat
    var height: CGFloat
    var imgName: String?
    var action: () -> Void      // ActionHandler
    var cornerRadius: CGFloat
    
    internal init(buttonName: String,
                  backgroundColor1: Color,
                  backgroundColor2: Color,
                  fontColor: Color = .white,
                  fontSize: CGFloat = 20,
                  fontIsBold: Bool = true,
                  width: CGFloat,
                  height: CGFloat = 45,
                  imgName: String = "",
                  action: @escaping () -> Void,
                  cornerRadius: CGFloat = 15) {
        self.buttonName = buttonName
        self.backgroundColour1 = backgroundColor1
        self.backgroundColour2 = backgroundColor2
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.fontIsBold = fontIsBold
        self.width = width
        self.height = height
        self.imgName = imgName
        self.action = action
        self.cornerRadius = cornerRadius
    }

    var body: some View {
       Button(action: action, label: {
           HStack {
               Text(buttonName)
               if let systemImage = imgName {
                   Image(systemName: systemImage)
               }
           }
           .font(.system(size: fontSize, weight: fontIsBold ? .bold : .regular, design: .rounded))
           .frame(width: width,height: height,alignment: .center)
           .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(.linearGradient(colors: [backgroundColour1, backgroundColour2], startPoint: .topLeading, endPoint: .bottom)))
           .foregroundColor(fontColor)
           .cornerRadius(cornerRadius)
           
       })
    }
}

struct CommonButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CommonButton(buttonName: "Preview",
                         backgroundColor1: Color("main"),
                         backgroundColor2: Color("lightMain"),
                         width: 150) {}
                .preview(with: "CommonButton in default")
            
            CommonButton(buttonName: "Preview",
                         backgroundColor1:  Color("main"),
                         backgroundColor2:  Color("lightMain"),
                         fontColor: Color("mainRed"),
                         fontSize: 30,
                         fontIsBold: false,
                         width: 150) {}
                .preview(with: "CommonButton in font change")
            
            CommonButton(buttonName: "Preview",
                         backgroundColor1:  Color("main"),
                         backgroundColor2:  Color("lightMain"),
                         width: 150, imgName: "arrowshape.turn.up.right") {}
                .preview(with: "CommonButton with img")
        }
    }
}
