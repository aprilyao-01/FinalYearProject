//
//  MockAudioPlayer.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import AVFAudio

/// protocol for to testing AudioRecordingManager()
protocol AudioPlayerProtocol: AnyObject {
    var delegate: AudioPlayerDelegateProtocol? { get set }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    
    func play() -> Bool
    func stop()
    func prepareToPlay() -> Bool
}

//extension AVAudioPlayer: AudioPlayerProtocol {}


/// mock class for to testing AudioRecordingManager()
class MockAudioPlayer: AudioPlayerProtocol {
    weak var delegate: AudioPlayerDelegateProtocol?
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    
    init(delegate: AudioPlayerDelegateProtocol) {
        self.delegate = delegate
    }
    
    func play() -> Bool {
        isPlaying = true
        return true
    }
    
    func stop() {
        isPlaying = false
    }
    
    func prepareToPlay() -> Bool {
        return true
    }
}


protocol AudioPlayerDelegateProtocol: AnyObject {
    func audioPlayerDidFinishPlaying(_ player: AudioPlayerProtocol, successfully flag: Bool)
}

extension AudioRecordingManager: AudioPlayerDelegateProtocol {
    func audioPlayerDidFinishPlaying(_ player: AudioPlayerProtocol, successfully flag: Bool) {
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
}

