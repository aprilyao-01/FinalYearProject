//
//  ContactItemCell.swift
//  Guardian
//
//  Created by Siyu Yao on 05/01/2023.
//

import SwiftUI

struct ContactItemCell: View {
    @State var image: String
    @State var name: String
    @State var isEmergencyContact: Bool
    
    var body: some View {
        HStack{
            if (image == "") {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.gray)
                    .frame(width: 40,height: 40)
                    .font(.system(size: 40))
            } else {
                Image(image)
                    .resizable()
                    .frame(width: 40,height: 40)
            }
            
            Text(name)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
                .padding(.leading,2)
            Spacer()
            
            if isEmergencyContact{
                Image(systemName: "staroflife.fill")
//                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("mainRed"))
                    .frame(width: 25,height: 25)
                    .padding(.trailing,20)
            }
            
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 10,height: 17)
                .foregroundColor(Color.gray)
            
        }
        .background(Color.white)
    }
}

struct ContactItemCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContactItemCell(image: "", name: "John Emergency", isEmergencyContact: true)
                .preview(with: "Sample contact item")
            ContactItemCell(image: "", name: "John Normal", isEmergencyContact: false)
                .preview(with: "Sample contact item")
        }
    }
}
