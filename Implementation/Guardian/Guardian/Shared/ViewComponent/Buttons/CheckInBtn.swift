//
//  CheckInBtn.swift
//  Guardian
//
//  Created by Siyu Yao on 05/03/2023.
//

import SwiftUI

struct CheckInBtn: View {
    var buttonName: String
    var image: String
    var action: () -> Void
    @Binding var isCheckinTimerRunning: Bool
    @Binding var timerVal: Int
    
    var body: some View {
        ZStack {
            //MARK: background
            Circle()
                .foregroundColor(Color("lightMain"))
                .opacity(0.4)
                .frame(width: 120, height: 120)
            Button(action: {
                action()
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(Color("main"))
                        .opacity(0.8)

                    if isCheckinTimerRunning{
                        Text("\(timerVal)")
                            .font(.system(size: 30, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                    }else{
                        //MARK: img and text
                        VStack(spacing: 10) {
                            Image(systemName:  image)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text(buttonName)
                                .font(.system(size: 20, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    
                }
            })
        }
        
    }
}

struct CheckInBtn_Previews: PreviewProvider {
    static var previews: some View {
        CheckInBtn(buttonName: "check in", image: "", action: {}, isCheckinTimerRunning: .constant(true), timerVal: .constant(100))
            .preview(with: "CheckIn button")
    }
}
