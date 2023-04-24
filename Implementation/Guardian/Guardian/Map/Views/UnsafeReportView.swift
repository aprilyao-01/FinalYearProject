//
//  UnsafeReportView.swift
//  Guardian
//
//  Created by Siyu Yao on 08/03/2023.
//

import SwiftUI
import MapKit

struct UnsafeReportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: map properties
    @StateObject var mapVM: MapVM
    @State var showMapLocPicker: Bool = false
    @State var region: MKCoordinateRegion
    @State var pickedLocation: CLLocationCoordinate2D
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: choose location
                Text("Where did you find it?")
                    .font(.title2)
                
                Text("Longitude: \(pickedLocation.longitude)")
                    .font(.system(size: 13))
                    .padding(.bottom,5)
                Text("Latitude: \(pickedLocation.latitude)")
                    .font(.system(size: 13))
                    .padding(.bottom,20)
                    
                CommonButton(buttonName: "My Current Location", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    region = MKCoordinateRegion(center: mapVM.userLocation?.coordinate ?? MapDetails.startingLocation,
                                                     span: MapDetails.span)
                    pickedLocation = CLLocationCoordinate2D(latitude: mapVM.userLocation?.coordinate.latitude ?? MapDetails.startingLocation.latitude, longitude: mapVM.userLocation?.coordinate.longitude ?? MapDetails.startingLocation.longitude)
                })
                
                CommonButton(buttonName: "Pick Location on Map", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    showMapLocPicker.toggle()
                })
                
                // MARK: submit
                CommonButton(buttonName: "Add Report", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    presentationMode.wrappedValue.dismiss()
                    mapVM.addReportItem(reportType: mapVM.selectedReportType.rawValue, locLong: pickedLocation.longitude, locLat: pickedLocation.latitude)
                })
                .padding(.top, 150)
                
                // MARK: pick location navigation
                NavigationLink ("", destination: SelectLocationOnMap(mapVM: mapVM, region: $region, pickedLocation: $pickedLocation), isActive: $showMapLocPicker)
            }
            .navigationBarBackButtonHidden(true)
            .applyClose()
        }
    }
}

struct UnsafeReportView_Previews: PreviewProvider {
    static var previews: some View {
        UnsafeReportView(mapVM: MapVM(), region: MKCoordinateRegion(), pickedLocation: MapDetails.startingLocation)
    }
}
