//
//  PinDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 10/03/2023.
//

import SwiftUI

enum Report {
    case Unsafe
    case PoorLight
    case Restricted
    case Missing
}

struct PinDetails: View {
    
    var reportDistance: Float
    var reportType: Report
    var reportNumber: Int
    var timeFrame: String
    
    // MARK: diff type with diff img and title
    var imgName: String = ""
    var title: String = ""
    
    internal init(reportDistance: Float, reportType: Report, reportNumber: Int, timeFrame: String, imgName: String = "", title: String = "") {
        self.reportDistance = reportDistance
        self.reportType = reportType
        self.reportNumber = reportNumber
        self.timeFrame = timeFrame
        
        // deter info based on type
        switch reportType {
        case .Unsafe:
            self.imgName = "xmark.shield.fill"
            self.title = "Feels Unsafe"
        case .PoorLight:
            self.imgName = "lightbulb.fill"
            self.title = "Poor Lighting"
        case .Restricted:
            self.imgName = "hand.raised.slash.fill"
            self.title = "Restricted Access"
        case .Missing:
            self.imgName = "person.fill.questionmark.rtl"
            self.title = "Missing Person"
        }
        
    }
    
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
                    (Text(title)
                        .font(.title.bold())
                     + Text("\n\(reportDistance, specifier: "%.2f") metres away")
                        .font(.title2))
                    
                    Button {
                       // TODO: dismiss
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
                    Text("Has reported this:  \(reportNumber) times")
                        .font(.headline)
                    
                    Text("Timeframe")
                        .padding(.trailing, 200)
                    Text("First reported in: \(timeFrame)")
                        .font(.headline)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.leading, 20)
                    Text("     Looks like solved?")
                }
                .padding(.trailing, 30)
                .padding(.bottom, 20)
            }
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 350, height: 260)
            }
            
            // MARK: delete btn
            CommonButton(buttonName: "All Good", backgroundColor1: Color("lightRed"), backgroundColor2: Color("lightRed"), width: 180, imgName: "trash", action: {})
                .padding(.top, 270)
            
        }
    }
}

struct PinDetails_Previews: PreviewProvider {
    static var previews: some View {
        PinDetails( reportDistance: 48.9, reportType: Report.Unsafe, reportNumber: 2, timeFrame: "March - 03")
            .preview(with: "Example Pin")
    }
}
