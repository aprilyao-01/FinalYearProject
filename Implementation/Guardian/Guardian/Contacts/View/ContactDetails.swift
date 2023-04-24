//
//  contactDetails.swift
//  Guardian
//
//  Created by Siyu Yao on 25/12/2023.
//

import SwiftUI

struct ContactDetails: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedContactItem: EmergencyContact
    @StateObject var contactVM: ContactVM
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView{
            VStack{
                if (selectedContactItem.profileImage == "" ) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                } else {
                    Image(selectedContactItem.profileImage)
                        .resizable()
                        .frame(width: 100,height: 100)
                }
            
                Text(selectedContactItem.contactName)
                    .foregroundColor(Color.black)
                    .font(.system(size: 18))
                    .padding(.top,10)
                
                TextFieldWithHeading(label: "Phone Number", textFieldValue: $selectedContactItem.phoneNo, placeholder: "Enter phone number", isLockButtonEnabled: true, isPasswordField: false,isEnabled: true)
                    .padding(.top,10)

                HStack{
                    Text("Emergency Contact")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16))
                    Spacer()
                    Toggle(isOn: $selectedContactItem.isEmergencyContact, label: {})
                }
                .padding(.top,20)
                    
                CommonButton(buttonName: "Delete Contact", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 250, action: {
                    contactVM.deleteContact(item: selectedContactItem, completion: {})
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.top,15)

            }
            .padding(.horizontal, 15)
        }
        .withNavBar(leftImg: "chevron.left", leftAction: {
            self.presentationMode.wrappedValue.dismiss()
            contactVM.updateContact(item: selectedContactItem, completion: {})
        }, rightAction: {})
        .navigationBarBackButtonHidden(true)
    }
}

struct contactDetails_Previews: PreviewProvider {
    static var previews: some View {
        let sample = EmergencyContact(contactName: "John Preview", isEmergencyContact: true, phoneNo: "23455678", profileImage: "")
        
        ContactDetails(selectedContactItem: .constant(sample), contactVM: ContactVM())
            .preview(with: "Modify contact done navigation bar")
    }
}
