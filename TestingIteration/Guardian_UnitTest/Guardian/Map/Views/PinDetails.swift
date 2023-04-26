//
//  PinDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 10/03/2023.
//

import SwiftUI


struct PinDetails: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var reportDistance: Float
    @State var reportType: Report
    @State var reportNumber: Int
    @State var timeFrame: String
    
    // MARK: diff type with diff img and title
    @State var imgName: String = ""
    @State var title: String = ""
    @Binding var showPlaceDetails: Bool
    @StateObject var mapVM: MapVM
    @ObservedObject var annotationItem: ReportItem
    
    var body: some View {
        ZStack {
            VStack{
                // MARK: type info
                HStack{
                    Image(systemName: imgName)
                        .font(.system(size: 30))
                        .background(
                            Circle()
                                .blur(radius: 5)
                                .foregroundColor(Color("lightRed"))
                        )
                        .foregroundColor(.black.opacity(0.8))
                    VStack{
                        Text(title)
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
                
                
                // MARK: source info
                VStack(spacing: 8){
                    Text("Source")
                        .padding(.trailing, 200)
                        .foregroundColor(.black)
                    Text("Has reported this:  \(reportNumber) times")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("Timeframe")
                        .padding(.trailing, 200)
                        .foregroundColor(.black)
                    Text("First reported in: \(timeFrame)")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.leading, 20)
                    Text("     Looks like solved?")
                        .foregroundColor(.black)
                }
                .padding(.bottom, 20)
            }
            
            // MARK: delete btn
            CommonButton(buttonName: "All Good", backgroundColor1: Color("lightRed"), backgroundColor2: Color("lightRed"), width: 180, imgName: "trash", action: {
                showPlaceDetails.toggle()
                mapVM.deleteReportItem(reportItem: annotationItem, completion: {})
            })
                .padding(.top, 260)
            
        }
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 350, height: 260)
        }
        .onAppear(){
            setUIData()
        }
    }
    
    func setUIData(){
        switch reportType {
        case .Unsafe:
            imgName = "xmark.shield.fill"
            title = "Feels Unsafe"
        case .PoorLight:
            imgName = "lightbulb.fill"
            title = "Poor Lighting"
        case .Restricted:
            imgName = "hand.raised.slash.fill"
            title = "Restricted Access"
        case .Missing:
            imgName = "person.fill.questionmark.rtl"
            title = "Missing Person"
        }
    }
}

struct PinDetails_Previews: PreviewProvider {
    static var previews: some View {
        PinDetails(reportDistance: 48.9, reportType: Report.Unsafe, reportNumber: 2, timeFrame: "March - 03", showPlaceDetails: .constant(true), mapVM: MapVM(), annotationItem: ReportItem(reportType: 0, locLongitude: 53.2345, locLatitude: 2.3456, reportedTime: "21-03-2023", reportedBy: "by", deleteRequestedBy: [], missingPersonGender: "F", missingPersonName: "Bob", missingPersonAge: "8", missingPersonWornCloths: "white cloth", missingPersonImage: "", reportingConfirmedByUsers: []))
            .preview(with: "Example Pin")
    }
}
