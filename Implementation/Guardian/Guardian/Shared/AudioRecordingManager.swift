//
//  AudioRecordingManager.swift
//  Guardian
//
//  Created by Siyu Yao on 19/03/2023.
//

import Foundation
import AVFoundation
import FirebaseStorage
import UIKit
import FirebaseAuth

struct Recording : Equatable {
    let fileURL : URL
    let createdAt : Date
    var isPlaying : Bool
}

class AudioRecordingManager : NSObject, ObservableObject , AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let activityIndicator = ActivityIndicator()
    var indexOfPlayer = 0
    @Published var recordingsList = [Recording]()
    @Published var toggleColor : Bool = false
    let storageRef = Storage.storage().reference()
    let fileManager = FileManager.default
    let currentUID = Auth.auth().currentUser == nil ? "test" : Auth.auth().currentUser!.uid
    @Published var currentTime : Double = 0.0
    var timer: Timer = Timer()
    
    var playingURL : URL?
    let formatter = DateComponentsFormatter()
    @Published var formattedDuration: String = ""
    @Published var formattedProgress: String = "00:00"

    override init(){
        super.init()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]

    }
    
    private static var settingsStore : AudioRecordingManager = {
        let settings = AudioRecordingManager()
        return settings
    }()
    
    @objc class func shared() -> AudioRecordingManager {
        return settingsStore
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("SOS : \(SharedMethods.dateToStringConverter(date: Date())).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //uploading th recorded audio to firebase
        let recordingRef = storageRef.child("recordings/\(currentUID)/\(recorder.url.lastPathComponent)")
        let metaData = StorageMetadata()
        _ = recordingRef.putFile(from: recorder.url, metadata: metaData) { metadata, error in
          guard let metadata = metadata else {
            return
          }
            _ = metadata.size
        }
    }
    
    func downloadRecordingsFromFirebase(){
        self.recordingsList = []
        DispatchQueue.main.async{
            self.activityIndicator.showActivityIndicator()
        }
        let docDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let directoryPath = docDirPath.appendingPathComponent("recordings")
        if !fileManager.fileExists(atPath: directoryPath) { //check whether local dir "recordings" exists inside documents and if not create dir
            try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        let localURL = URL(fileURLWithPath: directoryPath)
        
        let storageReference = storageRef.child("recordings/\(currentUID)")
        storageReference.listAll { (result, error) in   //list all saved recordings from firebase
            if error != nil {
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                    SharedMethods.showMessage("Error", message: error?.localizedDescription, onVC: UIApplication.topViewController())

                }
            }
            
            if result?.items.count == 0{
                DispatchQueue.main.async{
                    self.activityIndicator.hideActivityIndicator()
                    SharedMethods.showMessage("Message", message: "Recording list empty", onVC: UIApplication.topViewController())
                }
            }
            
            for item in (result?.items ?? []) {
                let finalStorRef = storageReference.child(item.name)
                let finalLocalPath = localURL.appendingPathComponent(item.name)
                
                _ = finalStorRef.write(toFile: finalLocalPath) { url, error in   //download recording files 1 by 1
                    if result?.items.last == item{
                        DispatchQueue.main.async{
                            self.activityIndicator.hideActivityIndicator()
                        }
                    }
                    if let error = error {
                        print(error)
                    } else {
                        if url != nil{
                            self.recordingsList.append(Recording(fileURL : url!, createdAt:self.getFileDate(for: url!), isPlaying: false))
                        }

                    }
                }
            }
        }
    }
    
//    func fetchAllRecording(){
//        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let recDirectory = path.appendingPathComponent("recordings")
//        let directoryContents = try! fileManager.contentsOfDirectory(at: recDirectory, includingPropertiesForKeys: nil)
//        for i in directoryContents {
//            recordingsList.append(Recording(fileURL : i, createdAt:getFileDate(for: i), isPlaying: false))
//        }
//        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
//    }
    
    
    func startPlaying(url : URL) {
        playingURL = url
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer.duration))!
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.currentTime =  TimeInterval(self.audioPlayer.currentTime)
                self.formattedProgress = self.formatter.string(from: TimeInterval(self.audioPlayer.currentTime))!

            }
            
            if audioPlayer.isPlaying{
                audioPlayer.stop()
                timer.invalidate()
                self.currentTime = 0.0
            }else{
                audioPlayer.play()
            }
          
            
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }else{
                    recordingsList[i].isPlaying = false
                }
            }
        } catch {
            print("Playing Failed")
        }
    }
    
    func stopPlaying(url : URL) {
        audioPlayer.stop()
        timer.invalidate()
        self.currentTime = 0.0
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
 
    func deleteRecording(url : URL) {
        let storageReference = storageRef.child("recordings/\(currentUID)")
        
        let recFileRef = storageReference.child(url.lastPathComponent)
        
        // Delete the file
        recFileRef.delete { error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                self.deleteFileFromLocalPath(url: url)
            }
        }
    }
    
    func deleteFileFromLocalPath(url : URL){
        do {
            try self.fileManager.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        for i in 0..<self.recordingsList.count {
            if self.recordingsList[i].fileURL == url {
                if self.recordingsList[i].isPlaying == true{
                    self.stopPlaying(url: self.recordingsList[i].fileURL)
                }
                self.recordingsList.remove(at: i)
                
                break
            }
        }
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
}
