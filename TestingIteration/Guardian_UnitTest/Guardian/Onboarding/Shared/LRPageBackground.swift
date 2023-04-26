//
//  LRPageBackground.swift
//  Guardian
//
//  Created by Siyu Yao on 20/12/2023.
//

import SwiftUI

struct LRPageBackground: View {
    var isRed: Bool
    var isFirst: Bool = false
    
    var body: some View {
        Circle()
            .foregroundColor(isRed ? Color("lightRed") : Color("lightMain"))
            .offset(x: -200, y:-400)
        Circle()
            .scale(0.8)
            .foregroundColor(isRed ? Color("mainRed") : Color("main"))
            .offset(x: -40, y:-450)
        Circle()
            .foregroundColor((isRed||isFirst) ? Color("lightRed") : Color("lightMain"))
            .offset(x: 200, y:400)
        Circle()
            .scale(0.8)
            .foregroundColor((isRed||isFirst) ? Color("mainRed") : Color("main"))
            .offset(x: 40, y:450)
    }
}

struct LRPageBackground_Previews: PreviewProvider {
    static var previews: some View {
        LRPageBackground(isRed: true)
    }
}
