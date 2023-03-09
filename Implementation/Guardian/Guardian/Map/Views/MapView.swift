//
//  MapView.swift
//  Guardian
//
//  Created by Siyu Yao on 16/01/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var mapVM = MapVM()
    @State var trackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapVM.region, showsUserLocation: true, userTrackingMode: $trackingMode)
                .edgesIgnoringSafeArea(.all)
                .accentColor(Color("mainRed"))
                .onAppear{ mapVM.checkLocationServicesisEnable()
                }
            
            CommonButton(buttonName: "New Report", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 250, imgName: "doc.badge.plus", action: {
                
            })
            .padding(.top, 500)
        }
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView().preview(with: "Map")
    }
}
