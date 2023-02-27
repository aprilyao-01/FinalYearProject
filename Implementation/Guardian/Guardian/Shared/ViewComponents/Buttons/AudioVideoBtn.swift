//
//  AudioVideoBtn.swift
//  Guardian
//
//  Created by Siyu Yao on 24/02/2023.
//

import SwiftUI

// TODO: change this into toggle?
struct AudioVideoBtn: View {
    
    var buttonName: String
    var img_on: String
    var img_off: String
    @State private var is_active: Bool
    var action: () -> Void
    
    internal init(buttonName: String,
                  img_on: String,
                  img_off: String,
                  is_active: Bool = true,
                  action: @escaping () -> Void) {
        self.buttonName = buttonName
        self.img_on = img_on
        self.img_off = img_off
        self.is_active = is_active
        self.action = action
    }
    
    var body: some View {
        ZStack {
//            Toggle(isOn: $is_active){
//                Label(buttonName, systemImage: is_active ? img_on : img_off)
//            }
//                .toggleStyle(.button)
//                .foregroundColor(Color("main"))
//                .frame(width: 100, height: 40)
//
            //MARK: background
            Circle()
                .foregroundColor(Color("lightMain").opacity(is_active ? 0.4 : 0.2))
                .frame(width: 180, height: 180)
            Button(action: {
                action()
                is_active.toggle()
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 120, height: 120, alignment: .center)
                        .foregroundColor(Color("main").opacity(is_active ? 0.8 : 0.3))

                    //MARK: img and text
                    VStack(spacing: 10) {
                        Image(systemName: is_active ? img_on : img_off)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Text(buttonName)
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            })
        }
        
    }
}

struct AudioVideoBtn_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AudioVideoBtn(buttonName: "Audio", img_on: "speaker.wave.1.fill", img_off: "speaker.slash.fill", action: {})
                .preview(with: "Audio button")
            AudioVideoBtn(buttonName: "Video", img_on: "video.fill", img_off: "video.slash.fill", action: {})
                .preview(with: "video button")
        }
    }
}
