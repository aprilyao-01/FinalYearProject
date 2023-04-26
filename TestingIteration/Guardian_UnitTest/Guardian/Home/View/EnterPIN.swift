//
//  EnterPIN.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import SwiftUI
import AlertToast

struct EnterPIN: View {
    
    // MARK: PIN numbers
    @State var pin1: String = ""
    @State var pin2: String = ""
    @State var pin3: String = ""
    @State var pin4: String = ""
    
    @ObservedObject var homeVM : HomeVM
    @ObservedObject var locationManager: MapVM
    @StateObject var contactVM: ContactVM
    @StateObject var accountVM: AccountVM
    
    var userName: String
    
    // handle dark mode
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 40){
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color("mainRed"))
                .font(.system(size: 100))
                .padding(.top, 100)
            
            // avaliable time
            Text("Sending message to your emergency contacts in \(homeVM.timerVal) s")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(colorScheme == .light ? .black.opacity(0.7) : .white)
                .frame(alignment: .center)
            
            VStack (spacing: 20){
                PINTextField(pin1: $pin1, pin2: $pin2, pin3: $pin3, pin4: $pin4)
                    .padding(.top, 10)
                
                // contdown remaining pin enter time
                (Text("Enter your PIN to cancel\nyou still have\n")
                    .font(.system(size: 16, design: .rounded))
                 + Text("\(homeVM.remainingRetryCount)")
                    .font(.system(size: 26, design: .rounded))
                 + Text(" times")
                    .font(.system(size: 16, design: .rounded))
                )
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .light ? .black.opacity(0.7) : .white)
            }
           
            Spacer()
            
            CommonButton(buttonName: "Confirm Cancel", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                homeVM.cancelTimer(userEnteredPIN: "\(pin1)\(pin2)\(pin3)\(pin4)", actualPIN: accountVM.currentUser.PIN)
                pin1 = ""
                pin2 = ""
                pin3 = ""
                pin4 = ""
            })
            .padding(.bottom, 200)
        }
        .onAppear(){
            homeVM.remainingRetryCount = 3
            homeVM.timerVal = 10
        }
        .onReceive(homeVM.timer) { _ in
            if (homeVM.timerVal == 0 || homeVM.remainingRetryCount == 0) {
                homeVM.sendEmergencyMessage(userName: userName, coordinate: locationManager.userLocation?.coordinate, contactList: contactVM.fetchedContactList)
            }else{
                homeVM.timerVal -= 1
                print("timerVal: \(homeVM.timerVal)")
                print("remainingRetryCount: \(homeVM.remainingRetryCount)")
            }
        }
        .navigationBarHidden(true)
    }
}

struct EnterPIN_Previews: PreviewProvider {
    static var previews: some View {
        EnterPIN(homeVM: HomeVM(), locationManager: MapVM(), contactVM: ContactVM(), accountVM: AccountVM(), userName: "")
    }
}
