//
//  AudioRecordingManagerTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 02/04/2023.
//

import XCTest
@testable import Guardian


final class AudioRecordingManagerTests: XCTestCase {
    var sut_shared: AudioRecordingManager!
    var sut_audioRecordingManager: AudioRecordingManager!
    var url: URL!
    

    override func setUp() {
        super.setUp()
        sut_shared = AudioRecordingManager.shared()
        sut_audioRecordingManager = AudioRecordingManager()
        url = URL(fileURLWithPath: "testFile.m4a")
//        sut_audioRecordingManager.audioPlayer = MockAudioPlayer(delegate: sut_audioRecordingManager)
    }

    override func tearDown() {
        sut_shared = nil
        sut_audioRecordingManager = nil
        url = nil
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
        // When
        sut_audioRecordingManager.startPlaying(url: url)

        // Then
        XCTAssertTrue(sut_audioRecordingManager.audioPlayer.isPlaying, "Audio player should be playing.")
    }

    func testStopPlaying() {
        // When
        sut_audioRecordingManager.startPlaying(url: url)
        sut_audioRecordingManager.stopPlaying(url: url)

        // Then
        XCTAssertFalse(sut_audioRecordingManager.audioPlayer.isPlaying, "Audio player should not be playing.")
    }
    
    func testAudioPlayerDidFinishPlaying() {
        sut_audioRecordingManager.recordingsList = [Recording(fileURL: url, createdAt: Date(), isPlaying: true)]
        sut_audioRecordingManager.playingURL = sut_audioRecordingManager.recordingsList[0].fileURL
        
        // When
        sut_audioRecordingManager.audioPlayerDidFinishPlaying(sut_audioRecordingManager.audioPlayer!, successfully: true)
        
        // Then
        XCTAssertFalse(sut_audioRecordingManager.recordingsList[0].isPlaying, "Audio player should not be playing after finishing.")
        
        // Given
        let url1 = URL(fileURLWithPath: "path/to/recording1")
        let url2 = URL(fileURLWithPath: "path/to/recording2")
        let recording1 = Recording(fileURL: url1, createdAt: Date(), isPlaying: true)
        let recording2 = Recording(fileURL: url2, createdAt: Date(), isPlaying: false)

        sut_audioRecordingManager.recordingsList = [recording1, recording2]
        sut_audioRecordingManager.playingURL = url1

        // When
        sut_audioRecordingManager.audioPlayerDidFinishPlaying(sut_audioRecordingManager.audioPlayer!, successfully: true)

        // Then
        XCTAssertFalse(sut_audioRecordingManager.recordingsList[0].isPlaying, "The isPlaying property of the first recording should be set to false after audioPlayerDidFinishPlaying is called")
        XCTAssertFalse(sut_audioRecordingManager.recordingsList[1].isPlaying, "The isPlaying property of the second recording should not be changed")
    }

        
    /// Verify if the putFile method of the MockStorageReference is called correctly
    func testAudioRecorderDidFinishRecording() {
        // Given
        let mockStorageReference = MockStorageReference()
        sut_audioRecordingManager.storageRef = mockStorageReference
        
        let recordingURL = URL(fileURLWithPath: "path/to/recording")
        let settings: [String: Any] = [:] // use an empty settings dictionary for testing purposes
        
        // force-unwrap the result since this is a test case, and any error would indicate a problem
        let mockAudioRecorder = try! MockAudioRecorder(url: recordingURL, settings: settings)
        
        sut_audioRecordingManager.audioRecorder = mockAudioRecorder
        
        // When
        sut_audioRecordingManager.audioRecorderDidFinishRecording(sut_audioRecordingManager.audioRecorder, successfully: true)
        
        // Then
        XCTAssertTrue(mockStorageReference.putFileCalled, "putFile method should be called on MockStorageReference")
    }
    

    func testDeleteFileFromLocalPath() {
        // Given
        sut_audioRecordingManager.recordingsList = [Recording(fileURL: url, createdAt: Date(), isPlaying: false)]
        
        // When
        sut_audioRecordingManager.deleteFileFromLocalPath(url: url)
        
        // Then
        XCTAssertTrue(sut_audioRecordingManager.recordingsList.isEmpty, "Recordings list should be empty after deleting the file.")
    }
    
    /// checks if the file date is within a 5-second range of the current date
    func testGetFileDate() {
        // Given, create a test file
        FileManager.default.createFile(atPath: url.path, contents: Data(), attributes: nil)
        defer { try? FileManager.default.removeItem(at: url) } // Clean up the test file after the test
        
        // When
        let fileDate = sut_audioRecordingManager.getFileDate(for: url)
        let currentDate = Date()
        
        // Then
        XCTAssert(abs(fileDate.timeIntervalSince(currentDate)) < 5, "File date should be within a 5-second range of the current date.")
    }
    
    /// Verify if the delete method of the MockStorageReference is called correctly
    func testDeleteRecording() {
        let mockStorageReference = MockStorageReference()
        sut_audioRecordingManager.storageRef = mockStorageReference
        
        let recordingURL = URL(fileURLWithPath: "path/to/recording")
        
        sut_audioRecordingManager.deleteRecording(url: recordingURL)
        
        
        XCTAssertTrue(mockStorageReference.deleteCalled, "delete method should be called on MockStorageReference")
    }
    
    /// Verify if the listAll method of the MockStorageReference is called correctly/
    func testDownloadRecordingsFromFirebase() {
        // Given
        let mockStorageReference = MockStorageReference()
        sut_audioRecordingManager.storageRef = mockStorageReference

        // When
        sut_audioRecordingManager.downloadRecordingsFromFirebase()

        // Then
        XCTAssertTrue(mockStorageReference.listAllCalled, "listAll method should be called on MockStorageReference")
        
        
        // Given, test the for loop
        let itemCount = 2
        let items = (0..<itemCount).map { _ in MockStorageReference() }
        let listResult = TestStorageListResult(items: items)

        mockStorageReference.listAllResult = listResult

        let semaphore = DispatchSemaphore(value: 0)
        sut_audioRecordingManager.activityIndicator = MockActivityIndicator {
            semaphore.signal()
        }

        // When
        sut_audioRecordingManager.downloadRecordingsFromFirebase()

        _ = semaphore.wait(timeout: .now() + 10) // Adjust the timeout as needed

        // Then
        XCTAssertEqual(sut_audioRecordingManager.recordingsList.count, itemCount, "The number of recordings downloaded should be equal to the number of items in the result")
    }


}
