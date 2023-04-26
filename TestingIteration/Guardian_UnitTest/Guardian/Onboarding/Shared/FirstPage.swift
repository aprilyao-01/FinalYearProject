//
//  FirstPage.swift
//  Guardian
//
//  Created by Siyu Yao on 20/01/2023.
//

import SwiftUI

struct FirstPage: View {
    // handle dark mode
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            LRPageBackground(isRed: false, isFirst: true)
//                .padding(.bottom, 70)
            
            Text("Welcome")
                .foregroundColor(colorScheme == .light ? .black : .white)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .padding(.bottom, 500)
             
            LRPageButton(isRed: false)
                .padding(.bottom,120)
            LRPageButton(isRed: true)
                .padding(.top,90)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
            FirstPage()
    }
}
