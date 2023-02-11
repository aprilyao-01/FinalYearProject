//
//  Home.swift
//  Guardian
//
//  Created by Siyu Yao on 15/12/2023.
//

import SwiftUI
import MapKit

struct Home: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        HStack{
            profileImage(myWidth: 50, myHeight: 50)
            Spacer()
            // TODO: set other things
            Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
        }
        Spacer()
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Home().environmentObject(SessionServiceImpl())
        }
    }
}
