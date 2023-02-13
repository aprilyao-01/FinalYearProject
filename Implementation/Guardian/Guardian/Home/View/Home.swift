//
//  Home.swift
//  Guardian
//
//  Created by Siyu Yao on 15/12/2023.
//

import SwiftUI
import MapKit

struct Home: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var homeVM = HomeVM()
    @StateObject var contactVM = ContactVM()
    
    //MARK: other views control properties
    @State var showProfileView: Bool = false
    
    var body: some View {
        VStack (spacing: 30){
            HStack{
                NavigationLink(destination: {
                    UserProfile()
                        .environmentObject(sessionService)
                }, label: {
                    profileImage(myWidth: 50, myHeight: 50)
                })
                
                Spacer()
                // TODO: set other things
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            .padding(.top,0)
            MapView()
            Spacer()
            MainButton(buttonName: "SOS", action: {}, onPressEnded: {
                homeVM.getHelpButtonTapped()})
            Spacer()
        }
        .fullScreenCover(isPresented: $showProfileView, content: {
            UserProfile()
        })
        .navigationBarBackButtonHidden(true)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Home().environmentObject(SessionServiceImpl())
        }
    }
}
