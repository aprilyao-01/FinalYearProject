//
//  doneNavBar.swift
//  Guardian
//
//  Created by Siyu Yao on 05/02/2023.
//

import SwiftUI

struct doneNavBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedContactItem: EmergencyContact
    @StateObject var contactVM: ContactVM
    
    var body: some View {
        HStack{
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 13,height: 22)
                    .foregroundColor(Color.gray)
            })
            
            Spacer()
            
            CommonButton(buttonName: "Done", backgroundColor1: .clear, backgroundColor2: .clear, fontColor: .green, fontSize: 18, fontIsBold: false, width: 60) {
                contactVM.updateContact(item: selectedContactItem)
                presentationMode.wrappedValue.dismiss()
            }
           
        }
        .padding(.top,2)
    }
}

struct doneNavBar_Previews: PreviewProvider {
    static var previews: some View {
        let sample = EmergencyContact(contactName: "", isEmergencyContact: true, phoneNo: "", profileImage: "")
        
        doneNavBar(selectedContactItem: .constant(sample), contactVM: ContactVM())
            .preview(with: "Modify contact done navigation bar")
    }
}
