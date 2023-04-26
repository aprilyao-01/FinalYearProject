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

/// protocol for to testing AudioRecordingManager()
protocol AudioRecorderProtocol {
    var delegate: AVAudioRecorderDelegate? { get set }
    var isRecording: Bool { get }
    var url: URL { get set }
    
    func prepareToRecord() -> Bool
    func record()
    func stop()
    
    init?(url: URL, settings: [String: Any]) throws
}

/// mock class for to testing AudioRecordingManager()
class MockAudioRecorder: NSObject, AudioRecorderProtocol, AVAudioRecorderDelegate {
    var delegate: AVAudioRecorderDelegate?
    var isRecording: Bool = false
    var url: URL

    required init?(url: URL, settings: [String: Any]) throws {
        self.url = url
        }

    func prepareToRecord() -> Bool {
        return true
    }

    func record() {
        isRecording = true
    }

    func stop() {
        isRecording = false
    }
}

