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
    
    @State var showMissing : Bool = false
    @State var showUnsafe : Bool = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapVM.region, showsUserLocation: true, userTrackingMode: $trackingMode)
                .ignoresSafeArea()
                .accentColor(Color("mainRed"))
                .onAppear{ mapVM.checkLocationServicesisEnable()
                }
            
            Button {
                // back to userlocation as center
            } label: {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("main").opacity(0.8))
                    }
            }
            .padding(.bottom, 700)
            .padding(.leading, 300)
            
            Menu{
                Button {
                    showMissing = true
                } label: {
                    Label("Report Missing Person", systemImage: "person.fill.questionmark.rtl")
                }
                
                Button {
                    showUnsafe = true
                } label: {
                    Label("Restricted Access", systemImage: "hand.raised.slash.fill")
                }
                
                Button {
                    showUnsafe = true
                } label: {
                    Label("No Streetlights", systemImage: "lightbulb.fill")
                }
                
                Button {
                    showUnsafe = true
                } label: {
                    Label("Feels Unsafe", systemImage: "xmark.shield.fill")
                }
            } label: {
                Label("New Report", systemImage: "doc.badge.plus")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                 .fill(.linearGradient(colors: [Color("mainRed"), Color("lightRed")], startPoint: .topLeading, endPoint: .bottom)))
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .padding(.top, 600)
            
            // MARK: navigation links
            NavigationLink ("", destination: MissingReportView(), isActive: $showMissing)
//            NavigationLink ("", destination: UnsafeReportView(), isActive: $showUnsafe)
        }
        .sheet(isPresented: $showUnsafe, content: {UnsafeReportView()})
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView().preview(with: "Map")
    }
}
