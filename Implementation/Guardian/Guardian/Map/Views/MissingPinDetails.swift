//
//  MissingPinDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 23/03/2023.
//

import SwiftUI

struct MissingPinDetails: View {
    @Environment(\.presentationMode) var presentationMode

    @State var reportDistance: Float
    @State var timeFrame: String
    
    @Binding var showPlaceDetails: Bool
    @StateObject var mapVM: MapVM
    @ObservedObject var annotationItem: ReportItem
    @State var userImage: UIImage?
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image(systemName: "person.fill.questionmark.rtl")
                        .font(.system(size: 30))
                        .background(
                            Circle()
                                .blur(radius: 5)
                                .foregroundColor(Color("lightRed"))
                        )
                        .foregroundColor(.black.opacity(0.8))
                    VStack{
                        Text("Missing Person")
                            .font(.title.bold())
                        Text("\(reportDistance, specifier: "%.2f") metres away")
                            .font(.title2)
                    }
                    .frame(minWidth: 220, maxWidth: .infinity,minHeight: 45)
                    
                    Button {
                        showPlaceDetails.toggle()
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .padding(.leading, 40)
                    }
                }
                .foregroundColor(.white)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray)
                        .frame(width: 350, height: 80)
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
                // MARK: source info
                VStack(alignment: .leading){
                    HStack{
                        VStack(alignment: .leading){
                            MissingPersonDescriptionRow(title: "Name :", subtitle: annotationItem.missingPersonName)
                            MissingPersonDescriptionRow(title: "Age :", subtitle: annotationItem.missingPersonAge)
                            MissingPersonDescriptionRow(title: "Gender :", subtitle: annotationItem.missingPersonGender)
                        }
                        Spacer()
                        if userImage != nil{
                            Image(uiImage: userImage!)
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .padding(.trailing,10)
                        }
                        

                    }
                    MissingPersonDescriptionRow(title: "Description :", subtitle: annotationItem.missingPersonWornCloths)
                    
                    Text("Timeframe")
                        .foregroundColor(.black)
                    Text("First reported in: \(timeFrame)")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.leading,-15)
                    Text("     Looks like solved?")
                        .foregroundColor(.black)
                        .padding(.bottom,15)
                    
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 15)

            }
            .frame(width: 350)
            
            VStack{
                Spacer()
                CommonButton(buttonName: "All Good", backgroundColor1: Color("lightRed"), backgroundColor2: Color("lightRed"), width: 180, imgName: "trash", action: {
                    showPlaceDetails.toggle()
                    mapVM.deleteReportItem(reportItem: annotationItem)
                })
                .padding(.bottom, -22.5)

            }

        }
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 350)
        }
        .onAppear(){
            userImage = annotationItem.missingPersonImage.toImage()
        }
    }
}

struct MissingPersonDescriptionRow: View{
    @State var title: String
    @State var subtitle: String
    var body: some View{
        HStack{
            Text(title)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            Text(subtitle)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(.leading, 5)
//                .frame(maxWidth: 250)
               
        }
        .padding(.bottom,5)
    }
}

struct MissingPinDetails_Previews: PreviewProvider {
    static var previews: some View {
        MissingPinDetails(reportDistance: 2.4, timeFrame: "23-03-2023", showPlaceDetails: .constant(true), mapVM: MapVM(), annotationItem: ReportItem(reportType: 0, locLongitude: 53.2345, locLatitude: 2.3456, reportedTime: "21-03-2023", reportedBy: "by", deleteRequestedBy: [], missingPersonGender: "F", missingPersonName: "Bob", missingPersonAge: "8", missingPersonWornCloths: "white cloth", missingPersonImage: "", reportingConfirmedByUsers: []))
    }
}
