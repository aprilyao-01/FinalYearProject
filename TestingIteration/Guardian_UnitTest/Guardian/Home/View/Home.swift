//
//  Home.swift
//  Guardian
//
//  Created by Siyu Yao on 15/12/2023.
//

import SwiftUI
import MapKit
import AlertToast

struct Home: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var homeVM = HomeVM()
    @ObservedObject var locationManager =  MapVM()
    @StateObject var contactVM = ContactVM()
    @StateObject var accountVM = AccountVM()
    
    //MARK: contacts
    @State var contactsViewHeight : CGFloat = 90
    let screenSize = UIScreen.main.bounds.size
    
    //MARK: audio recording properties
    @State var isAudioRecordingEnabled: Bool = true
    @State var showRecordingStatusChangeToast: Bool = false
    @State var isRecordingStarted: Bool = false
    
    //MARK: check in properties
    @State var showCheckInTimeView: Bool = false
    @State var isCheckinTimerRunning: Bool = false
    
    var body: some View {
        VStack (spacing: 30){
            ZStack {
                VStack {
                    //MARK: hearder info
                    HStack{
                        //MARK: show profile image and username
                        HStack {
                            ProfileImage(accountVM: accountVM, myWidth: 50, myHeight: 50)
                            
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
                                Text("Latitude: \(userLocation.coordinate.latitude, specifier: "%.2f") \nLongitude:  \(userLocation.coordinate.longitude, specifier: "%.2f")")
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
                    //MARK: audio and checkIn btns
                    HStack{
                        AudioBtn(buttonName: "Audio", img_on: "speaker.wave.1.fill", img_off: "speaker.slash.fill", action: {
                            isAudioRecordingEnabled.toggle()
                        })
                        Spacer()
                        CheckInBtn(buttonName: "Check In", image: "clock.badge.checkmark", action: {
                            showCheckInTimeView.toggle()
                        },isCheckinTimerRunning: $isCheckinTimerRunning,timerVal: $homeVM.checkInTimerVal)
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    Text("Hold the button")
                    Text("release to send help")
                    Spacer()
                    MainButton(buttonName: "SOS", action: {}, onPressEnded: {
                        if !isCheckinTimerRunning{
                            endSOSAction()
                        }
                    }, onPressStarted: {
                        if isCheckinTimerRunning{
                            SharedMethods.showMessage("Warning", message: "Checkin timer is already running", onVC: UIApplication.topViewController())
                        }else{
                            startSOSAction()
                        }
                        
                    })
                    .padding(.bottom,90)
                    Spacer()
                }
                
                //MARK: Contacts
                VStack {
                    Spacer()
                    Contacts(contactVM: contactVM)
                        .frame(height: contactsViewHeight)
                        .gesture(
                            DragGesture()
                                .onEnded { endedGesture in
                                    if (endedGesture.location.y - endedGesture.startLocation.y) > 0 {
                                        contactsViewHeight = 90
                                    } else {
                                        contactsViewHeight = screenSize.height*0.7
                                    }
                                }
                        )
                }
            }
        }
        // MARK: full screen - Check in timer
        .fullScreenCover(isPresented: $showCheckInTimeView, content: {
            CheckInTimeSet(homeVM: homeVM, onCheckInTimerStarted: {
                isCheckinTimerRunning.toggle()
                startSOSAction()
            }, isCheckinTimerRunning: $isCheckinTimerRunning, onCheckInTimerStoped: {
                if isAudioRecordingEnabled{ //on checkin time stop button press
                    showRecordingStatusChangeToast.toggle()
                    isRecordingStarted.toggle()
                    homeVM.arManager.stopRecording()
                }
            })
        })
        // MARK: full screen - sos count down
        .fullScreenCover(isPresented: $homeVM.showAlertCancelView, content: {
            if homeVM.alertCancelationViewType == .alertCancelationView{
                AlertCountDown(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM, userName: sessionService.userDetail?.fullName ?? sessionService.userDetail?.userName ?? "")
            }else{
                EnterPIN(homeVM: homeVM, locationManager: locationManager, contactVM: contactVM, accountVM: accountVM, userName: sessionService.userDetail?.fullName ?? sessionService.userDetail?.userName ?? "")
            }
        })
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            accountVM.fetchCurrentUser(completion: {_ in })
        }
        .toast(isPresenting: $showRecordingStatusChangeToast){
            AlertToast(displayMode: .hud, type: .complete(.green), title: isRecordingStarted ? "Recording started" : "Recording ended")
        }
        .onChange(of: homeVM.checkInTimerVal, perform: {timerVal in
            if timerVal == 0{
                isCheckinTimerRunning.toggle()
                endSOSAction()
            }
        })
    }
    
    func startSOSAction(){
        if isAudioRecordingEnabled{
            showRecordingStatusChangeToast.toggle()
            isRecordingStarted.toggle()
            homeVM.arManager.startRecording()
        }
    }
    
    func endSOSAction(){
        if isAudioRecordingEnabled{
            showRecordingStatusChangeToast.toggle()
            isRecordingStarted.toggle()
            homeVM.arManager.stopRecording()
        }
        homeVM.getHelpButtonTapped()

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Home().environmentObject(SessionServiceImpl(authSignOut: FirebaseAuthWrapper()))
        }
    }
}
