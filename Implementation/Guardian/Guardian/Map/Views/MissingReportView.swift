//
//  MissingReportView.swift
//  Guardian
//
//  Created by Siyu Yao on 07/03/2023.
//

import SwiftUI

struct MissingReportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var name: String = ""
    @State var age: String = ""
    @State var character: String = ""
    
    var body: some View {
        ScrollView{
            // MARK: choose location
            VStack {
                HStack {
                    Text("Where were they last seen?")
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
                    Text("Tell us a little about them")
                        .font(.system(size: 25, design: .rounded))
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                HStack {
                    CommonButton(buttonName: "Female", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 150, action: {
                        
                    })
                    
                    CommonButton(buttonName: "Male", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 150, action: {
                        
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
                
                CommonButton(buttonName: "", backgroundColor1: .gray.opacity(0.35), backgroundColor2: .gray.opacity(0.35), width: 150, height: 150, imgName: "camera", action: {
                    
                })
            }
            .padding(.bottom, 20)
            
            // MARK: submit
            CommonButton(buttonName: "Report missing Person", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                
            })
            .padding(.top, 30)
            
            
        }
        .navigationBarBackButtonHidden(true)
        .withNavBar(leftImg: "chevron.left", leftAction: {
            presentationMode.wrappedValue.dismiss()
        }, midTitle: "Report a Missing Person", midFont:.title2 ,rightAction: {})
    }
}

struct MissingReportView_Previews: PreviewProvider {
    static var previews: some View {
        MissingReportView()
    }
}
