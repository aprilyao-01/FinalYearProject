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
        Map(coordinateRegion: $mapVM.region, showsUserLocation: true, userTrackingMode: $trackingMode)
//            .frame(height: 250)
            
            .accentColor(Color("mainRed"))
//            .cornerRadius(15)
//            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("lightMain"), lineWidth: 1))
//            .padding(.horizontal,10)
            .onAppear{ mapVM.checkLocationServicesisEnable()
            }
            .edgesIgnoringSafeArea(.all)
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView().preview(with: "Map")
    }
}
