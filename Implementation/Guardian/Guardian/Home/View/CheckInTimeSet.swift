//
//  CheckInTimeSet.swift
//  Guardian
//
//  Created by Siyu Yao on 03/03/2023.
//

import SwiftUI

struct CheckInTimeSet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment (\.colorScheme) var colorScheme
    
    @State var timerValue: String = "1"
    @ObservedObject var homeVM: HomeVM
    let onCheckInTimerStarted: () -> Void
    @Binding var isCheckinTimerRunning: Bool
    let onCheckInTimerStoped: () -> Void
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Select countdown time")
                    .bold()
                    .padding(.bottom,30)
                    .font(.system(size: 20))
                HStack{
                    //MARK: stopwatch
                    ZStack{
                        //MARK: img
                        ZStack{
                            Image("stopwatch")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(colorScheme == .light ? .black.opacity(0.7) : .white)
                                .frame(width: 150,height: 150)
                            Circle()
                                .foregroundColor(Color("lightGray"))
                                .frame(width: 120,height: 120)
                                .padding(.top,12)

                        }
                        //MARK: text
                        VStack(alignment: .center){
                            TextField("", text: $timerValue)
                                .font(.system(size: 35))
                                .foregroundColor( .black.opacity(0.7))
                                .frame(width: 100)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)

                            Text("min")
                                .font(.system(size: 20))
                                .foregroundColor( .black.opacity(0.7))

                        }
                        .padding(.top,10)
                    }
                    
                    Spacer()
                    //MARK: preset times
                    VStack{
                        HStack{
                            
                            CommonButton(buttonName: CustomTimerTypes.min15.name, backgroundColor1: Color("lightMain"), backgroundColor2: Color("lightMain"), width: 100, action: {
                                timerValue = "\(CustomTimerTypes.min15.rawValue)"
                            },cornerRadius: 30)
                            CommonButton(buttonName: CustomTimerTypes.min30.name, backgroundColor1: Color("lightMain"), backgroundColor2: Color("lightMain"), width: 100, action: {
                                timerValue = "\(CustomTimerTypes.min30.rawValue)"

                            },cornerRadius: 30)
                        }
                        
                        HStack{
                            
                            CommonButton(buttonName: CustomTimerTypes.min45.name, backgroundColor1: Color("lightMain"), backgroundColor2: Color("lightMain"), width: 100, action: {
                                timerValue = "\(CustomTimerTypes.min45.rawValue)"

                            },cornerRadius: 30)
                            CommonButton(buttonName: CustomTimerTypes.min60.name, backgroundColor1: Color("lightMain"), backgroundColor2: Color("lightMain"), width: 100, action: {
                                timerValue = "\(CustomTimerTypes.min60.rawValue)"

                            },cornerRadius: 30)
                        }
                    }
                    
                }
                
                // MARK: start&stop button
                if isCheckinTimerRunning{
                    CommonButton(buttonName: "Stop Timer", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 200, action: {
                        isCheckinTimerRunning.toggle()
                        presentationMode.wrappedValue.dismiss()
                        homeVM.endCheckinTimer()
                        onCheckInTimerStoped()
                        
                    },cornerRadius: 30)
                    .padding(.top, 50)
                }else{
                    CommonButton(buttonName: "Start Timer", backgroundColor1: Color("mainRed"), backgroundColor2: Color("lightRed"), width: 200, action: {
                        presentationMode.wrappedValue.dismiss()
                        homeVM.checkInTimerVal = (Int(timerValue) ?? 0)*60
                        homeVM.startCheckinTimer()
                        onCheckInTimerStarted()
                    },cornerRadius: 30)
                    .padding(.top, 50)

                }

                Spacer()

            }
            .padding(.horizontal,15)
            .navigationBarBackButtonHidden(true)
            .withNavBar(leftImg: "chevron.left", leftAction: {
                presentationMode.wrappedValue.dismiss()
            }, midTitle: "Check In", midColour: colorScheme == .light ? .black : .white, rightAction: {})

        }

    }
}

struct CheckInTimeSet_Previews: PreviewProvider {
    static var previews: some View {
        CheckInTimeSet(homeVM: HomeVM(), onCheckInTimerStarted: {}, isCheckinTimerRunning: .constant(false), onCheckInTimerStoped: {})
    }
}
