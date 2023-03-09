//
//  UnsafeReportView.swift
//  Guardian
//
//  Created by Siyu Yao on 09/03/2023.
//

import SwiftUI

struct UnsafeReportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var name: String = ""
    @State var age: String = ""
    @State var character: String = ""
    
    var body: some View {
        ScrollView {
            // MARK: choose location
            VStack {
                HStack {
                    Text("Where did you find it?")
                        .font(.system(size: 25, design: .rounded))
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                    
                CommonButton(buttonName: "My Current Location", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    
                })
                
                CommonButton(buttonName: "Pick Location on Map", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    
                })
            }
            .padding(.bottom, 20)
            
            // MARK: detail
            VStack(spacing: 30) {
                HStack {
                    Text("Choose a Category")
                        .font(.system(size: 25, design: .rounded))
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                CommonButton(buttonName: "Feels Unsafe", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 200, imgName: "xmark.shield.fill", action: {
                    
                })
                
                CommonButton(buttonName: "No Streetlights", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 200, imgName: "lightbulb.fill", action: {
                    
                })
                
                CommonButton(buttonName: "Restricted Access", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 230, imgName: "hand.raised.slash.fill", action: {
                    
                })
            }
            .padding(.bottom, 20)
            
            // MARK: submit
            CommonButton(buttonName: "Add Report", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                
            })
            .padding(.top, 150)
            
            
        }
        .withNavBar(leftImg: "chevron.left", leftAction: {
            presentationMode.wrappedValue.dismiss()
        }, midTitle: "Report a Potential Unsafe", rightAction: {})
    }
}

struct UnsafeReportView_Previews: PreviewProvider {
    static var previews: some View {
        UnsafeReportView()
    }
}
