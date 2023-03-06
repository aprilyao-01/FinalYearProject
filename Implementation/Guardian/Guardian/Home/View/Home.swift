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
    @ObservedObject var locationManager =  MapVM()
    @StateObject var contactVM = ContactVM()
    
    //MARK: contacts
    @State var contactsViewHeight : CGFloat = 90
    let screenSize = UIScreen.main.bounds.size
    
    //MARK: other views control properties
    @State var showProfileView: Bool = false
    
    var body: some View {
        VStack (spacing: 30){
            HStack{
                NavigationLink(destination: {
                    UserProfile()
                        .environmentObject(sessionService)
                }, label: {
                    ProfileImage(myWidth: 50, myHeight: 50)
                })
                
                Spacer()
                // TODO: set other things
                Text("place holder")
//                Image(systemName: "gearshape.fill")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(.gray)
            }
            //.padding(.top,0)
            //MapView()
//            HStack{
//                AudioVideoBtn(buttonName: "Audio", img_on: "speaker.wave.1.fill", img_off: "speaker.slash.fill", action: {})
//                    .preview(with: "Audio button")
//                AudioVideoBtn(buttonName: "Video", img_on: "video.fill", img_off: "video.slash.fill", action: {})
//                    .preview(with: "video button")
//            }
            Spacer()
            MainButton(buttonName: "SOS", action: {}, onPressEnded: {
                homeVM.getHelpButtonTapped()})
            
            Contacts(contactVM: contactVM)
                .frame(height: contactsViewHeight)
                .gesture(
                    DragGesture()
                        .onEnded { endedGesture in
                            if (endedGesture.location.y - endedGesture.startLocation.y) > 0 {
                                contactsViewHeight = 90
                            } else {
                                contactsViewHeight = screenSize.height*0.9
                            }
                        }
                )
            
        }
        .fullScreenCover(isPresented: $showProfileView, content: {
            UserProfile()
        })
        .fullScreenCover(isPresented: $homeVM.showAlertCancelView, content: {
            if homeVM.alertCancelationViewType == .alertCancelationView{
                AlertCountDown(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM)
            }else{
                EnterPIN(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM)
            }
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
