//
//  AudioManage.swift
//  Guardian
//
//  Created by Siyu Yao on 06/03/2023.
//

import SwiftUI

struct AudioManage: View {
    @ObservedObject var arManager = AudioRecordingManager.shared()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false){
                ForEach(arManager.recordingsList, id: \.createdAt) { recording in
                    AudioCell(arManager: arManager, recording: recording)
                }
            }
            
        }
        .padding(.top,30)
        .padding(.horizontal,15)
        .navigationBarTitle("Recordings")
        .onAppear(){
            arManager.downloadRecordingsFromFirebase()
        }
        .onDisappear(){
            if arManager.audioPlayer != nil{
                arManager.audioPlayer.stop()
            }
            
        }
    }
}

struct AudioManage_Previews: PreviewProvider {
    static var previews: some View {
        AudioManage()
    }
}
