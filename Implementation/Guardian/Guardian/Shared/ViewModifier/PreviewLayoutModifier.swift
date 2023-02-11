//
//  PreviewLayoutModifier.swift
//  Guardian
//
//  Created by Siyu Yao on 31/01/2023.
//

import SwiftUI

struct PreviewLayoutModifier: ViewModifier {
    
    var name: String
    
    func body(content: Content) -> some View{
        content
            .previewLayout(.sizeThatFits)
            .previewDisplayName(name)
            .padding()
    }
}


extension View {
    func preview(with name: String) -> some View {
        self.modifier(PreviewLayoutModifier(name: name))
    }
}
