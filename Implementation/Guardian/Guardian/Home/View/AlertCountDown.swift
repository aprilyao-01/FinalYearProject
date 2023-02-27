//
//  AlertCancel.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import SwiftUI

struct AlertCountDown: View {
    // MARK: view propoties
    @ObservedObject var homeVM : HomeVM
    @ObservedObject var locationManager: MapVM
    @StateObject var contactVM: ContactVM
    
    var body: some View {
        VStack(spacing: 40){
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color("mainRed"))
                .font(.system(size: 100))
                .padding(.top, 100)
            
            // contdown
            Text("Sending message to your emergency contacts in \(homeVM.timerVal) s")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
            
            Spacer()
            
            CommonButton(buttonName: "Cancel", backgroundColor1: Color("mainRed"), backgroundColor2: Color("mainRed"), width: 200, action: {
                // Cancel -> to enter PIN
                homeVM.showAlertCancelView.toggle()
                homeVM.alertCancelationViewType = .alertCancelationConfView
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    homeVM.showAlertCancelView.toggle()
                }
            })
            .padding(.top, 50)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear(){
            homeVM.timerVal = 10
        }
        .onReceive(homeVM.timer) { _ in
            if homeVM.timerVal > 0 {
                homeVM.timerVal -= 1
            }else{
                homeVM.sendEmergencyMessage(coordinate: locationManager.userLocation?.coordinate, contactList: contactVM.fetchedContactList)
            }
        }
        .navigationBarHidden(true)
    }
}

struct AlertCancel_Previews: PreviewProvider {
    static var previews: some View {
        AlertCountDown(homeVM: HomeVM(), locationManager: MapVM(), contactVM: ContactVM())
    }
}
