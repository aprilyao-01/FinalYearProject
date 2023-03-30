//
//  SelectLocationOnMap.swift
//  Guardian
//
//  Created by Siyu Yao on 19/03/2023.
//

import SwiftUI
import MapKit

struct SelectLocationOnMap: View {
    @StateObject var mapVM: MapVM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var region: MKCoordinateRegion
    @Binding var pickedLocation: CLLocationCoordinate2D
    @State var pinImg = "mappin"
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("Select Location on map")
                    .font(.title)
                    .padding(.bottom,10)
                
                Text("Longitude: \(region.center.longitude)")
                    .font(.system(size: 13))
                    .padding(.bottom,5)
                Text("Latitude: \(region.center.latitude)")
                    .font(.system(size: 13))
                    .padding(.bottom,5)

            }
            .padding(.leading,15)
            ZStack{
                Map(coordinateRegion: $region, showsUserLocation: true)
                CustomPin(pinImg: $pinImg, color: Color.red, width: 10, height: 25)
                    .padding(.bottom,12)
            }
            Spacer()
        }
        .onAppear(){
            region.span = MapDetails.span
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action: {
            pickedLocation = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
            presentationMode.wrappedValue.dismiss()
        }, label: {Text("Done")}))
    }
}

struct SelectLocationOnMap_Previews: PreviewProvider {
    static var previews: some View {
        SelectLocationOnMap(mapVM: MapVM(), region: .constant(MKCoordinateRegion()), pickedLocation: .constant(MapDetails.startingLocation))
    }
}
