//
//  MainButton.swift
//  Guardian
//
//  Created by Siyu Yao on 11/02/2023.
//

import SwiftUI

struct MainButton: View {
    
    var buttonName: String
    var radius: CGFloat
    var backgroundColour1: Color
    var backgroundColour2: Color
    var fontColor: Color
    var fontSize: CGFloat
    var action: () -> Void
    var onPressEnded: () -> Void
    var onPressStarted: () -> Void
    
    internal init(buttonName: String,
                  radius: CGFloat = 150,
                  backgroundColour1: Color = Color("lightRed"),
                  backgroundColour2: Color = Color("mainRed"),
                  fontColor: Color = .white,
                  fontSize: CGFloat = 23,
                  action: @escaping () -> Void,
                  onPressEnded: @escaping () -> Void,
                  onPressStarted: @escaping () -> Void) {
        self.buttonName = buttonName
        self.radius = radius
        self.backgroundColour1 = backgroundColour1
        self.backgroundColour2 = backgroundColour2
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.action = action
        self.onPressEnded = onPressEnded
        self.onPressStarted = onPressStarted
    }

    var body: some View {
        ZStack {
            //MARK: background
            Circle()
                .frame(width: radius*2,height: radius*2,alignment: .center)
            .foregroundColor(backgroundColour2.opacity(0.2))
            
            Circle()
                .frame(width: radius*1.5,height: radius*1.5,alignment: .center)
                .foregroundColor(backgroundColour2.opacity(0.5))
            
            //MARK: area with action
            Button(action: action, label: {
                ZStack {
                    LinearGradient(
                            gradient: Gradient(colors: [backgroundColour1, backgroundColour2]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    .mask(Circle().frame(width: radius,height: radius,alignment: .center))
                        
                    //MARK: img and text
                    VStack {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: fontSize))
                            .foregroundColor(fontColor)
                        Text(buttonName)
                            .font(.system(size: fontSize))
                            .foregroundColor(fontColor)
                            .bold()
                    }
                }
                .frame(width: radius,height: radius,alignment: .center)
            })
            .onLongPressGesture(minimumDuration: 2) {
            } onPressingChanged: { inProgress in
                if !inProgress{
                    onPressEnded()
                }else{
                    onPressStarted()
                }
            }
        }
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(buttonName: "SOS", action: {}, onPressEnded: {}, onPressStarted: {})
            .preview(with: "Main function button, release to send help")
    }
}


