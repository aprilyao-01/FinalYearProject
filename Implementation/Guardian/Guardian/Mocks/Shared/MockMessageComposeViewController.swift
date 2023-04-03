//
//  MockMessageComposeViewController.swift
//  Guardian
//
//  Created by Siyu Yao on 03/04/2023.
//

import Foundation
import MessageUI
import UIKit

/// protocol to test sendMessage()
protocol MessageComposeViewControllerProtocol: UIViewController {
    static func canSendText() -> Bool
    var recipients: [String]? { get set }
    var body: String? { get set }
    var messageComposeDelegate: MFMessageComposeViewControllerDelegate? { get set }
}

/// mock classs to test sendMessage()
class MockMessageComposeViewController: UIViewController, MessageComposeViewControllerProtocol {
    static var canSendTextResult = true
    var recipients: [String]?
    var body: String?
    var messageComposeDelegate: MFMessageComposeViewControllerDelegate?

    static func canSendText() -> Bool {
        return canSendTextResult
    }
}

/// wrapper, to conforms to MessageComposeViewControllerProtocol()
class MFMessageComposeViewControllerWrapper: MFMessageComposeViewController, MessageComposeViewControllerProtocol {
    override static func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
}









