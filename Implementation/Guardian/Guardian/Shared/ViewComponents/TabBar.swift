//
//  TabBar.swift
//  Guardian
//
//  Created by Siyu Yao on 11/02/2023.
//

import SwiftUI

struct TabBar: View {
    @State var current = "Home"
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $current){
                //FIXME: the current view
                MapView()
                    .tag("Map")
                Text("Home")
                    .tag("Home")
                Text("Missing")
                    .tag("Missing")
            }
            HStack(spacing: 0){
                TabButton(title: "Map", image: "map", selected: $current)
                Spacer(minLength: 0)
                TabButton(title: "Home", image: "house", selected: $current)
                Spacer(minLength: 0)
                TabButton(title: "Missing", image: "questionmark.square", selected: $current)
            }
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(Color("lightMain"))
            .clipShape(Capsule())
            .padding(.horizontal,20)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
