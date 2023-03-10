//
//  NavBarModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 12/02/2023.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    var leftImg: String
    var leftText: String
    var leftColour: Color
    var leftFontSize: CGFloat
    var leftAction: () -> Void
    
    var midTitle: String
    var midColour: Color
    var midFont: Font
    
    var rightImg: String
    var rightText: String
    var rightColour: Color
    var rightFontSize: CGFloat
    var rightAction: () -> Void
    
    
    func body(content: Content) -> some View{
        content
            .toolbar{
                //MARK: left element
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: leftAction, label: {
                        Label(leftText, systemImage: leftImg)
                        Text(leftText)
                    })
                    .foregroundColor(leftColour)
                    .font(.system(size: leftFontSize))
                }
                
                //MARK: middle element = title
                ToolbarItem(placement: .principal){
                    if let font = midFont {
                        Text(midTitle)
                            .foregroundColor(midColour)
                            .font(font.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                
                //MARK: right element
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: rightAction, label: {
                        Text(rightText)
                        Label(rightText, systemImage: rightImg)
                        
                    })
                    .foregroundColor(rightColour)
                    .font(.system(size: rightFontSize))
                }
            }
    }
}


extension View {
    func withNavBar(leftImg: String? = "",
                    leftText: String? = "",
                    leftColour: Color? = .gray,
                    leftFontSize: CGFloat? = 21,
                    leftAction: @escaping () -> Void,
                    midTitle: String? = "",
                    midColour: Color? = .black,
                    midFont: Font? = .title,
                    rightImg: String? = "",
                    rightText: String? = "",
                    rightColour: Color? = .gray,
                    rightFontSize: CGFloat? = 21,
                    rightAction: @escaping () -> Void
                    ) -> some View {
        self.modifier(NavBarModifier(
            leftImg: leftImg ?? "",
            leftText: leftText ?? "",
            leftColour: leftColour ?? .gray,
            leftFontSize: leftFontSize ?? 21,
            leftAction: leftAction,
            midTitle: midTitle ?? "",
            midColour: midColour ?? .black,
            midFont: midFont ?? .title,
            rightImg: rightImg ?? "",
            rightText: rightText ?? "",
            rightColour: rightColour ?? .gray,
            rightFontSize: rightFontSize ?? 21,
            rightAction: rightAction))
    }
}

struct NavBarModifier_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Text("NavBar")
                .withNavBar(leftImg: "chevron.left", leftText: "Back", leftAction: {
                    // TODO: goback
                }, midTitle: "NavBar", rightImg: "person.crop.circle.badge.plus", rightText: "Add", rightColour: .green, rightAction: {
                })
        }
    }
}
