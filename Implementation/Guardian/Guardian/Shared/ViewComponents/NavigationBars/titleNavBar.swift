//
//  backNavBar.swift
//  Guardian
//
//  Created by Siyu Yao on 05/02/2023.
//

import SwiftUI

struct titleNavBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    
    var body: some View {
        ZStack{
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10,height: 20)
                        .foregroundColor(Color.gray)
                })
                Spacer()
            }
            VStack(alignment: .center){
                Text(title)
                    .foregroundColor(Color.black)
                    .font(.system(size: 18))
            }
        }
        .padding(.top,2)
    }
}

struct backNavBar_Previews: PreviewProvider {
    static var previews: some View {
        titleNavBar(title: "Example back")
            .preview(with: "Back Navigation Bar")
    }
}
