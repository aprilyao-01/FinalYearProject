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
    
    
    var body: some View {
        NavigationView{
            VStack{
                ContactList(contactVM: contactVM, showContactDetailsView: $showContactDetailsView, selectedContactItem: $selectedContactItem)
                NavigationLink ("", destination: ContactDetails(selectedContactItem: $selectedContactItem, contactVM: contactVM), isActive: $showContactDetailsView)
            }
            .frame(maxWidth: .infinity)
            .withNavBar(leftText: "Contacts", leftColour: .black, leftAction: {
            }, midTitle: "    ______", midColour: .gray, rightImg: "person.crop.circle.badge.plus", rightColour: .green, rightAction: {
                showContactPickSheet.toggle()
            })
            .background(Color.white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .background(Color.white)
        .shadow(
            color: Color.gray.opacity(0.7),
            radius: 8,
            x: 0,
            y: 0
        )
        //MARK: sheet - add new contact
        .sheet(isPresented: $showContactPickSheet, onDismiss: nil) {
            ContactPickerView(selectedContacts: $contactVM.selectedContacts,contactPickingFinished: {
                contactVM.addContact()
                showContactPickSheet.toggle()
            })
        }
        .onAppear(){
            contactVM.fetchContact()
        }
        .onChange(of: contactVM.contactAddErrorMessage, perform: { message in
            if message != ""{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    SharedMethods.showMessage("Error", message: message, onVC: UIApplication.topViewController())
                }
            }
        })
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts(contactVM: ContactVM())
    }
}
