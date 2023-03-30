//
//  CustomAnnotaion.swift
//  Guardian
//
//  Created by Siyu Yao on 18/03/2023.
//

import SwiftUI
import CoreLocation

struct CustomAnnotation: View {
    
    @State private var showPlaceDetails = false
    @State var currentLocation: CLLocation
    @StateObject var mapVM: MapVM
    @ObservedObject var annotationItem: ReportItem
    @State var pinImg: String = ""
    
    var body: some View {
        let distanceInMeters = CLLocation(latitude: annotationItem.locLatitude, longitude: annotationItem.locLongitude).distance(from: currentLocation)
        
        VStack(spacing: 0) {
            ZStack{
                CustomPin(pinImg: $pinImg, color: Color.red, width: 25, height: 25)
                    .zIndex(-1)

                if showPlaceDetails{
                    if annotationItem.reportType == Report.Missing.rawValue{
                        MissingPinDetails(reportDistance: Float(distanceInMeters), timeFrame: annotationItem.reportedTime, showPlaceDetails: $showPlaceDetails, mapVM: mapVM, annotationItem: annotationItem)
                    }else{
                        PinDetails(reportDistance: Float(distanceInMeters), reportType: Report(rawValue: annotationItem.reportType) ?? Report.Unsafe, reportNumber: (annotationItem.reportingConfirmedByUsers.count + 1), timeFrame: annotationItem.reportedTime, showPlaceDetails: $showPlaceDetails, mapVM: mapVM, annotationItem: annotationItem)
                            .zIndex(2)

                    }

                }
            }
        }
        .onAppear(){
            pinImg = (Report(rawValue: annotationItem.reportType) ?? Report.Unsafe).pinImage
        }
        .onTapGesture {
            showPlaceDetails.toggle()
        }
    }
}

struct CustomAnnotaion_Previews: PreviewProvider {
    static var previews: some View {
        CustomAnnotation(currentLocation: CLLocation(latitude: 52.952082, longitude: -1.185445), mapVM: MapVM(), annotationItem: ReportItem(reportType: 0, locLongitude: 53.2345, locLatitude: 2.3456, reportedTime: "21-03-2023", reportedBy: "by", deleteRequestedBy: [], missingPersonGender: "F", missingPersonName: "Bob", missingPersonAge: "8", missingPersonWornCloths: "white cloth", missingPersonImage: "", reportingConfirmedByUsers: []))
            .preview(with: "unsafe pin")
    }
}
