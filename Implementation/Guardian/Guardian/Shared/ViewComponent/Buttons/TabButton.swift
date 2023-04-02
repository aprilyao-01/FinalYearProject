//
//  TabButton.swift
//  Guardian
//
//  Created by Siyu Yao on 12/02/2023.
//

import SwiftUI

struct TabButton: View {
    var title: String
    var image: String
    
    @Binding var selected: String
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()){selected = title}
        }, label: {
            HStack(spacing: 10){
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25,height: 25)
                    .foregroundColor(.white)
                
                if selected == title {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color("main").opacity(selected == title ? 0.6 : 0))
            .clipShape(Capsule())
        })
    }
}
