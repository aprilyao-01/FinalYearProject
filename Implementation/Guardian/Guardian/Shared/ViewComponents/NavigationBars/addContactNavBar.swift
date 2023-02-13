//
//  TopBar.swift
//  Guardian
//
//  Created by Siyu Yao on 05/01/2023.
//

import SwiftUI

struct addContactNavBar: View {
    @State var showContactPickSheet: Bool = false
    
    var body: some View {
        HStack{
            Text("Contacts")
                .font(.system(size: 18))
                .foregroundColor(Color.black)
            Spacer()
            Button(action: {
                showContactPickSheet.toggle()
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus")
//                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.green)
                    .font(.system(size: 25))
//                    .frame(width: 25,height: 25)
            })
            
        }
        .padding(.top,5)
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        addContactNavBar().preview(with: "Contacts topbar")
    }
}
