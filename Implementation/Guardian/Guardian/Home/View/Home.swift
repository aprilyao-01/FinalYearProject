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
                //MARK: show profile image and username
                HStack {
                    ProfileImage(myWidth: 50, myHeight: 50)
                    
                    (Text("Hi,")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                     + Text (verbatim: "\n\(sessionService.userDetail?.userName ?? "")")
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    )
                    .lineSpacing(5)
                }
                
                Spacer()
                
                //MARK: show location in text
                VStack(spacing:5) {
                    if let userLocation = locationManager.userLocation {
                        Text("\(userLocation)")
                        NavigationLink(destination: MapView(), label: {
                            Text("See location")
                            Image(systemName: "mappin")
                        })
                        .foregroundColor(Color("mainRed"))
                        .font(.system(size: 16, design: .rounded))
                    } else {
                        Text("Restricted Location")
                            .foregroundColor(Color("mainRed"))
                            .font(.system(size: 18))
                        Label("Go to \"Settings\"\nand turn \"Location\" on", systemImage: "gear")
                            .font(.system(size: 16))
                    }
                    
                }
            }
            .padding(.horizontal, 20)
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
            UserAccount()
        })
        .fullScreenCover(isPresented: $homeVM.showAlertCancelView, content: {
            if homeVM.alertCancelationViewType == .alertCancelationView{
                AlertCountDown(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM, userName: sessionService.userDetail?.fullName ?? sessionService.userDetail?.userName ?? "")
            }else{
                EnterPIN(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM, userName: sessionService.userDetail?.fullName ?? sessionService.userDetail?.userName ?? "")
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
