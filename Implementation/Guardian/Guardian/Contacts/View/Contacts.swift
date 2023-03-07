//
//  Contacts.swift
//  Guardian
//
//  Created by Siyu Yao on 25/01/2023.
//

import SwiftUI
import Firebase
import FirebaseDatabase


struct Contacts: View {
    @StateObject var contactVM: ContactVM
    @State var showContactPickSheet: Bool = false
    @State var showContactDetailsView: Bool = false
    @State var selectedContactItem: EmergencyContact = EmergencyContact(contactName: "", isEmergencyContact: false, phoneNo: "", profileImage: "")
//    @State var isLoading: Bool = true
    
    
    var body: some View {
        NavigationView{
            VStack{
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: 120,height: 6,alignment: .center)
//                    .cornerRadius(8)
//                    .padding(.bottom,60)
//                addContactNavBar()
//                    .padding(.horizontal,15)
                NavigationLink ("", destination: ContactDetails(selectedContactItem: $selectedContactItem, contactVM: contactVM), isActive: $showContactDetailsView)
                ContactList(contactVM: contactVM)
                
            }
            .frame(maxWidth: .infinity)
            .withNavBar(leftImg: "arrow.up", leftText: "Drag", leftAction: {
                // TODO: goback
            }, midTitle: "Contacts", rightImg: "person.crop.circle.badge.plus", rightColour: .green, rightAction: {
                showContactPickSheet.toggle()
            })
//            .navigationTitle("Contacts")
            .background(Color.white)
//            .toast(isPresenting: $isLoading, alert: {})
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color.white)
//        .cornerRadius(20, corners: [.topLeft,.topRight])
        .shadow(
            color: Color.gray.opacity(0.7),
            radius: 8,
            x: 0,
            y: 0
        )
        .sheet(isPresented: $showContactPickSheet, onDismiss: nil) {
            ContactPickerView(selectedContacts: $contactVM.selectedContacts,contactPickingFinished: {
                contactVM.addContact()
                showContactPickSheet.toggle()
            })
        }
        .onAppear(){
            contactVM.fetchContact()
        }
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts(contactVM: ContactVM())
    }
}
