//
//  UnsafeReportView.swift
//  Guardian
//
//  Created by Siyu Yao on 08/03/2023.
//

import SwiftUI

struct UnsafeReportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var name: String = ""
    @State var age: String = ""
    @State var character: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: choose location
                Text("Where did you find it?")
                    .font(.title2)
                    
                CommonButton(buttonName: "My Current Location", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    
                })
                
                CommonButton(buttonName: "Pick Location on Map", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    
                })
                
                // MARK: submit
                CommonButton(buttonName: "Add Report", backgroundColor1: Color("main"), backgroundColor2: Color("lightMain"), width: 300, action: {
                    // TODO: add in db, and shows in view
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.top, 150)
            }
            .navigationBarBackButtonHidden(true)
            .applyClose()
        }
    }
}

struct UnsafeReportView_Previews: PreviewProvider {
    static var previews: some View {
        UnsafeReportView()
    }
}
