//
//  MockMessageComposeDelegate.swift
//  Guardian
//
//  Created by Siyu Yao on 03/04/2023.
//

import Foundation
import MessageUI

/// protocol for testing messageComposeViewController()
protocol MessageComposeViewControllerDelegateProtocol: AnyObject {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
}

/// mock class for testing messageComposeViewController()
class MockMessageComposeDelegate: MessageComposeViewControllerDelegateProtocol {
    var didFinishWithResultCalled = false
    var lastResult: MessageComposeResult?

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        didFinishWithResultCalled = true
        lastResult = result
    }
}
