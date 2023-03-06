//
//  ContactList.swift
//  Guardian
//
//  Created by Siyu Yao on 05/02/2023.
//

import SwiftUI

struct ContactList: View {
    @StateObject var contactVM: ContactVM
    @State var showContactDetailsView: Bool = false
    @State var selectedContactItem: EmergencyContact = EmergencyContact(contactName: "", isEmergencyContact: false, phoneNo: "", profileImage: "")
    
    var body: some View {
        VStack{
            List{
                ForEach(contactVM.fetchedContactList, id: \.self){ item in
                    ContactItemCell(image: item.profileImage, name: item.contactName, isEmergencyContact: item.isEmergencyContact)
                        .onTapGesture {
                            selectedContactItem = item
                            showContactDetailsView.toggle()
                        }
                        .listRowBackground(Color.white)

                }
                
            }
            .listStyle(.plain)

        }
        .padding(.top,10)
    }
}

struct contactList_Previews: PreviewProvider {
    static var previews: some View {
        ContactList(contactVM: ContactVM())
    }
}

