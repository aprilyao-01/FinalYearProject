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
                VStack(spacing:5) {
                    Text("show location as text")
                    CommonButton(buttonName: "See location", backgroundColor1: .clear, backgroundColor2: .clear, fontColor: Color("mainRed"), fontSize: 16, fontIsBold: false, width: 120, imgName: "mappin", action: {
                        // go to map page
                    })
                }
            }
            .padding(.horizontal, 20)
            //MapView()
            Spacer()
            HStack{
                AudioBtn(buttonName: "Audio", img_on: "speaker.wave.1.fill", img_off: "speaker.slash.fill", action: {})
                Spacer()
                AudioBtn(buttonName: "Check In", img_on: "clock.badge.checkmark", img_off: "clock.badge.xmark", action: {})
            }
            .padding(.horizontal, 20)
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
