//
//  HomeViewModel.swift
//  Guardian
//
//  Created by Siyu Yao on 15/12/2023.
//

import Combine
import SwiftUI
import MapKit
import MessageUI

enum AlertCancelationViewType{
    case alertCancelationView
    case alertCancelationConfView
}

protocol HomeViewModel {
    var timer:  Publishers.Autoconnect<Timer.TimerPublisher> { get }
    var timerVal: Int { get }
    var remainingRetryCount: Int { get }
    var alertCancelationViewType: AlertCancelationViewType { get }
    var showAlertCancelView: Bool { get }
    var showMessageUI: Bool { get }
    
    func getHelpButtonTapped()
    func cancelTimer(PIN: String)
    func endTimer()
    func sendEmergencyMessage(coordinate: CLLocationCoordinate2D?,contactList: [EmergencyContact])
    
}

class HomeVM: ObservableObject, HomeViewModel {
    
    // MARK: View Properties
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timerVal: Int = 10
    @Published var alertCancelationViewType: AlertCancelationViewType = .alertCancelationView
    @Published var showAlertCancelView: Bool = false
    @Published var showMessageUI: Bool = false
    @Published var remainingRetryCount: Int = 3
    
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
    func cancelTimer(PIN: String){
        if remainingRetryCount == 0{
            SharedMethods.showMessage("Error", message: "Please try again later", onVC: UIApplication.topViewController())
        }else{
            //check whether PIN is valid
            if SettingsStore.shared().appPIN == PIN{
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
    
    func sendEmergencyMessage(coordinate: CLLocationCoordinate2D?,contactList: [EmergencyContact]){
        endTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let contacts = contactList.filter({$0.isEmergencyContact}).map({$0.phoneNo})
            MessageHelper.shared.sendMessage(recipients: contacts, body: "Emergency alert \nLongitude:\(coordinate?.longitude ?? -1)\nLatitude:\(coordinate?.latitude ?? -1)")
        }
    }
}
