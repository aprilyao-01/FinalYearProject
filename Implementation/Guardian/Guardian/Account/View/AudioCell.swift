//
//  AudioCell.swift
//  Guardian
//
//  Created by Siyu Yao on 16/03/2023.
//

import SwiftUI

struct AudioCell: View {
    @ObservedObject var arManager: AudioRecordingManager
    let recording: Recording
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName:"waveform.circle")
                    .font(.system(size:50))
                
                //MARK: progress bar & audio info
                VStack(alignment:.leading) {
                    if arManager.audioPlayer != nil && recording.isPlaying{
                        // MARK: progress bar
                        ProgressView("Playing", value: arManager.currentTime, total: arManager.audioPlayer.duration)
                            .progressViewStyle(LinearProgressViewStyle()) // 1
                            .tint(.black)
                            .foregroundColor(.white)
                        //MARK: time duration
                        HStack{
                            Text(arManager.formattedProgress)
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                            Spacer()
                            Text(arManager.formattedDuration)
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                        }
                    }else{
                        // recording time
                        Text("\(recording.fileURL.lastPathComponent)")
                            .frame(maxWidth: .infinity)
                    }

                }
                //MARK: delete & play
                VStack {
                    //MARK: delete btn
                    Button(action: {
                        arManager.deleteRecording(url:recording.fileURL)
                    }) {
                        Image(systemName:"xmark.circle.fill")
                            .foregroundColor(Color("mainRed"))
                            .font(.system(size:20))
                    }
                    
                    Spacer()
                    
                    //MARK: play&stop btn
                    Button(action: {
                        if recording.isPlaying == true {
                            arManager.stopPlaying(url: recording.fileURL)
                        }else{
                            arManager.startPlaying(url: recording.fileURL)
                        }
                    }) {
                        Image(systemName: recording.isPlaying ? "stop.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size:30))
                    }
                    
                }
                
                Spacer()
                
            }
            .padding()
        }
        .padding(.horizontal,10)
        .background(Color("lightGray"))
        .cornerRadius(25)
        .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
    }
}

struct AudioCell_Previews: PreviewProvider {
    static var previews: some View {
        AudioCell(arManager:  AudioRecordingManager.shared(), recording: Recording(fileURL: URL(fileURLWithPath: ""), createdAt: Date(), isPlaying: false))
            .preview(with: "Empty audio")
    }
}
