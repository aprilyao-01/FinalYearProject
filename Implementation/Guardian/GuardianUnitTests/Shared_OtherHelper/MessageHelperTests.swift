//
//  MessageHelperTests.swift
//  GuardianUnitTests
//
//  Created by Siyu Yao on 03/04/2023.
//

import XCTest
import MessageUI

@testable import Guardian

final class MessageHelperTests: XCTestCase {

    func testMessageComposeViewControllerCallsDelegate() {
        // Given
        let mockDelegate = MockMessageComposeDelegate()
        MessageHelper.shared.delegate = mockDelegate

        // When
        let controller = MFMessageComposeViewController()
        let result: MessageComposeResult = .sent
        MessageHelper.shared.messageComposeViewController(controller, didFinishWith: result)

        // Then
        XCTAssertTrue(mockDelegate.didFinishWithResultCalled, "The delegate's messageComposeViewController(_:didFinishWith:) method should be called")
        XCTAssertEqual(mockDelegate.lastResult, result, "The delegate should receive the correct MessageComposeResult")
    }

    
    func testSendMessageSetsProperties() {
        // Given
        let mockMessageComposeViewController = MockMessageComposeViewController()
        let recipients = ["+1234567890"]
        let body = "Test message"

        // When
        MessageHelper.shared.sendMessage(recipients: recipients, body: body, messageComposeViewController: mockMessageComposeViewController)

        // Then
        XCTAssertEqual(mockMessageComposeViewController.recipients, recipients, "The recipients should be set correctly")
        XCTAssertEqual(mockMessageComposeViewController.body, body, "The message body should be set correctly")
        XCTAssertNotNil(mockMessageComposeViewController.messageComposeDelegate, "The messageComposeDelegate should be set")
    }

}
