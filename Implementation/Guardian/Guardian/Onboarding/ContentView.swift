//
//  ContentView.swift
//  Guardian
//
//  Created by Siyu Yao on 04/12/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            FirstPage()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
