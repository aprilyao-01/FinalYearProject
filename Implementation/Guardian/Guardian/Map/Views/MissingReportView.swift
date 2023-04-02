//
//  MissingReportView.swift
//  Guardian
//
//  Created by Siyu Yao on 07/03/2023.
//

import SwiftUI
import MapKit

struct MissingReportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: detail properties
    @State var name: String = ""
    @State var age: String = ""
    @State var character: String = ""
    
    //MARK: map properties
    @State var pickedLocation: CLLocationCoordinate2D
    @State var showMapLocPicker: Bool = false
    @StateObject var mapVM: MapVM
    @State var region: MKCoordinateRegion
    @State var selectedGender: GenderType = .male
    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var showingImagePicker: Bool = false
    @State var fetchedImageName: String?
    
    var body: some View {
        NavigationView {
            ScrollView{
                // MARK: choose location
                VStack {
                    HStack {
                        Text("Where were they last seen?")
                            .font(.system(size: 25, design: .rounded))
                            .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    .padding(.bottom, 15)
                    
                    // details
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
                    
                    NavigationLink ("", destination: SelectLocationOnMap(mapVM: mapVM, region: $region, pickedLocation: $pickedLocation), isActive: $showMapLocPicker)
                }
                .padding(.bottom, 20)
                
                // MARK: detail
                VStack(spacing: 30) {
                    HStack {
                        Text("Tell us a little about them")
                            .font(.system(size: 25, design: .rounded))
                            .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    
                    HStack {
                        CommonButton(buttonName: "Female", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 150, action: {
                            selectedGender = .female
                        })
                        
                        CommonButton(buttonName: "Male", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 150, action: {
                            selectedGender = .male
                        })
                    }
                    
                    CommonTextField(hint: "What's their name?", text: $name, width: 330)
                    CommonTextField(hint: "How old?", text: $age, width: 330)
                    CommonTextField(hint: "Describe what they were wearing", text: $character, width: 330)
                }
                .padding(.bottom, 20)
                
                // MARK: photo
                VStack {
                    HStack {
                        Text("Upload Photo from Library")
                            .font(.system(size: 25, design: .rounded))
                            .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    
                    VStack{
                        if mapVM.missingPersonImage != nil {
                            Image(uiImage: mapVM.missingPersonImage!)
                                .resizable()
                                .frame(width: 150, height: 150)
                            //                                .clipShape(Circle())
                            
                        }else{
                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150, alignment: .center)
                            //                                 .clipShape(Circle())
                        }
                        
                    }
                    .onTapGesture {
                        showingImagePicker.toggle()
                    }
                    .padding(.top,5)
                }
                .padding(.bottom, 20)
                
                // MARK: submit
                CommonButton(buttonName: "Report missing Person", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    presentationMode.wrappedValue.dismiss()
                    var personImage = ""
                    if mapVM.missingPersonImage != nil{
                        personImage = mapVM.missingPersonImage!.toJpegString(compressionQuality: 0.2) ?? ""
                    }
                    mapVM.addReportItem(reportType: Report.Missing.rawValue, locLong: pickedLocation.longitude, locLat: pickedLocation.latitude,missingPersonGender: selectedGender.name,missingPersonName: name, missingPersonAge: age, missingPersonWornCloths: character,missingPersonImage: personImage, completion: {})
                })
                .padding(.top, 30)
                
                
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $mapVM.missingPersonImage, sourceType: $sourceType, fileName: $fetchedImageName, showingImagePicker: $showingImagePicker)
            }
            .navigationBarBackButtonHidden(true)
            .withNavBar(leftImg: "chevron.left", leftAction: {
                presentationMode.wrappedValue.dismiss()
        }, midTitle: "Report a Missing Person", midFont:.title2 ,rightAction: {})
        }
    }
}

struct MissingReportView_Previews: PreviewProvider {
    static var previews: some View {
        MissingReportView(pickedLocation: MapDetails.startingLocation, mapVM: MapVM(), region: MKCoordinateRegion())
    }
}
