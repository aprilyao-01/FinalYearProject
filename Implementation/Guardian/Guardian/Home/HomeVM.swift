//
//  HomeViewModel.swift
//  Guardian
//
//  Created by Siyu Yao on 15/12/2023.
//

import Combine
import MapKit
import MessageUI

enum AlertCancelationViewType{
    case alertCancelationView
    case alertCancelationConfView
}

enum CustomTimerTypes: Int, CaseIterable{
    case min15 = 15
    case min30 = 30
    case min45 = 45
    case min60 = 60
    
    var name: String{
        get{
            switch self {
            case .min15:
                return "15 min"
            case .min30:
                return "30 min"
            case .min45:
                return "45 min"
            case .min60:
                return "60 min"
            }
        }
        
    }
}

protocol HomeViewModel {
    var timer:  Publishers.Autoconnect<Timer.TimerPublisher> { get }
    var timerVal: Int { get }
    var remainingRetryCount: Int { get }
    var alertCancelationViewType: AlertCancelationViewType { get }
    var showAlertCancelView: Bool { get }
    var showMessageUI: Bool { get }
    
    func getHelpButtonTapped()
    func cancelTimer(userEnteredPIN: String,actualPIN: String)
    func endTimer()
    func sendEmergencyMessage(userName: String, coordinate: CLLocationCoordinate2D?,contactList: [EmergencyContact])
    
}

class HomeVM: ObservableObject, HomeViewModel {
    
    // MARK: View Properties
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timerVal: Int = 10
    @Published var alertCancelationViewType: AlertCancelationViewType = .alertCancelationView
    @Published var showAlertCancelView: Bool = false
    @Published var showMessageUI: Bool = false
    @Published var remainingRetryCount: Int = 3
    @Published var arManager = AudioRecordingManager.shared()
    
    // MARK: check in Properties
    var checkInTimer = Timer()
    @Published var checkInTimerVal: Int = 0
    
    //MARK: action for get help button
    func getHelpButtonTapped(){
        if MFMessageComposeViewController.canSendText() {
            print("you are here")
            alertCancelationViewType = .alertCancelationView
            showAlertCancelView.toggle()
        }else{
            // only works in real device
            SharedMethods.showMessage("Error", message: "Can not send message with this device", onVC: UIApplication.topViewController())
        }
    }
    
    //MARK: cancel button action in PIN confirmation view
    func cancelTimer(userEnteredPIN: String,actualPIN: String){
        if remainingRetryCount == 0{
            SharedMethods.showMessage("Error", message: "Please try again later", onVC: UIApplication.topViewController())
        }else{
            //check whether PIN is valid
            if actualPIN == userEnteredPIN{
                timer.upstream.connect().cancel()
                showAlertCancelView.toggle()
            }else{
                remainingRetryCount -= 1
                SharedMethods.showMessage("Error", message: "Invalid PIN", onVC: UIApplication.topViewController())
            }
        }
       
    }
    
    
    func endTimer(){
        timer.upstream.connect().cancel()
        showAlertCancelView.toggle()
    }
    
    func sendEmergencyMessage(userName: String, coordinate: CLLocationCoordinate2D?,contactList: [EmergencyContact]){
        endTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let contacts = contactList.filter({$0.isEmergencyContact}).map({$0.phoneNo})
            MessageHelper.shared.sendMessage(recipients: contacts, body: "Emergency alert from \(userName) in: \nLongitude:\(coordinate?.longitude ?? -1)\nLatitude:\(coordinate?.latitude ?? -1)\nneed your help.")
        }
    }
    
    func startCheckinTimer(){
        checkInTimer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        checkInTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkInTimerAction), userInfo: nil, repeats: true)
    }
   
    func endCheckinTimer(){
        checkInTimer.invalidate()
        
    }
    
    // Timer.scheduledTimer needs Objective-C selector
    @objc func checkInTimerAction() {
        if checkInTimerVal > 0 {
            checkInTimerVal -= 1
        }else{
            endCheckinTimer()
        }
    }
}
