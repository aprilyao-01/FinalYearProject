//
//  AudioRecordingManagerTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 02/04/2023.
//

import XCTest
@testable import Guardian

class AudioRecordingManagerTests: XCTestCase {
    var sut_shared: AudioRecordingManager!
    var sut_audioRecordingManager: AudioRecordingManager!

    override func setUp() {
        super.setUp()
        sut_shared = AudioRecordingManager.shared()
        sut_audioRecordingManager = AudioRecordingManager()
    }

    override func tearDown() {
        sut_shared = nil
        sut_audioRecordingManager = nil
        super.tearDown()
    }

    func testSharedInstance() {
        // When
        let instance1 = AudioRecordingManager.shared()
        let instance2 = AudioRecordingManager.shared()
        
        // Then
        XCTAssert(instance1 === instance2, "Shared instances of AudioRecordingManager are not equal")
    }

    func testInitialState() {
        // Then
        XCTAssertTrue(sut_shared.recordingsList.isEmpty, "Recordings list should be initially empty")
        XCTAssertFalse(sut_shared.toggleColor, "Toggle color should be initially false")
        XCTAssertEqual(sut_shared.currentTime, 0.0, "Current time should be initially 0.0")
        XCTAssertEqual(sut_shared.formattedDuration, "", "Formatted duration should be initially empty")
        XCTAssertEqual(sut_shared.formattedProgress, "00:00", "Formatted progress should be initially '00:00'")
    }
        
    func testStartRecording() {
        // When
        sut_audioRecordingManager.startRecording()
        
        // Then
        XCTAssertTrue(sut_audioRecordingManager.audioRecorder.isRecording, "Audio recorder should be recording.")
    }

    func testStopRecording() {
        // When
        sut_audioRecordingManager.startRecording()
        sut_audioRecordingManager.stopRecording()
        
        // Then
        XCTAssertFalse(sut_audioRecordingManager.audioRecorder.isRecording, "Audio recorder should not be recording.")
    }
        
    func testStartPlaying() {
        // Given
        let url = URL(fileURLWithPath: "testFile.m4a")
        sut_audioRecordingManager.audioPlayer = MockAudioPlayer(delegate: sut_audioRecordingManager)
        
        // When
        sut_audioRecordingManager.startPlaying(url: url)

        // Then
        XCTAssertTrue(sut_audioRecordingManager.audioPlayer.isPlaying, "Audio player should be playing.")
    }

    func testStopPlaying() {
        // Given
        let url = URL(fileURLWithPath: "testFile.m4a")
        sut_audioRecordingManager.audioPlayer = MockAudioPlayer(delegate: sut_audioRecordingManager)
        
        // When
        sut_audioRecordingManager.startPlaying(url: url)
        sut_audioRecordingManager.stopPlaying(url: url)

        // Then
        XCTAssertFalse(sut_audioRecordingManager.audioPlayer.isPlaying, "Audio player should not be playing.")
    }
    
    func testAudioPlayerDidFinishPlaying() {
        // Given
        sut_audioRecordingManager.audioPlayer = MockAudioPlayer(delegate: sut_audioRecordingManager)
        sut_audioRecordingManager.recordingsList = [Recording(fileURL: URL(fileURLWithPath: "testFile1.m4a"), createdAt: Date(), isPlaying: true)]
        sut_audioRecordingManager.playingURL = sut_audioRecordingManager.recordingsList[0].fileURL
        
        // When
        sut_audioRecordingManager.audioPlayerDidFinishPlaying(sut_audioRecordingManager.audioPlayer!, successfully: true)
        
        // Then
        XCTAssertFalse(sut_audioRecordingManager.recordingsList[0].isPlaying, "Audio player should not be playing after finishing.")
    }
    

    func testDeleteFileFromLocalPath() {
        // Given
        let url = URL(fileURLWithPath: "testFile.m4a")
        sut_audioRecordingManager.recordingsList = [Recording(fileURL: url, createdAt: Date(), isPlaying: false)]
        
        // When
        sut_audioRecordingManager.deleteFileFromLocalPath(url: url)
        
        // Then
        XCTAssertTrue(sut_audioRecordingManager.recordingsList.isEmpty, "Recordings list should be empty after deleting the file.")
    }
    
    /// checks if the file date is within a 5-second range of the current date
    func testGetFileDate() {
        // Given
        let url = URL(fileURLWithPath: "testFile.m4a")
        
        // Create a test file
        FileManager.default.createFile(atPath: url.path, contents: Data(), attributes: nil)
        defer { try? FileManager.default.removeItem(at: url) } // Clean up the test file after the test
        
        // When
        let fileDate = sut_audioRecordingManager.getFileDate(for: url)
        let currentDate = Date()
        
        // Then
        XCTAssert(abs(fileDate.timeIntervalSince(currentDate)) < 5, "File date should be within a 5-second range of the current date.")
    }
}
