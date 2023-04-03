//
//  MessageHelper.swift
//  Guardian
//
//  Created by Siyu Yao on 31/01/2023.
//

import Foundation
import UIKit
import MessageUI


class MessageHelper: NSObject, MFMessageComposeViewControllerDelegate {
    
    public static let shared = MessageHelper()
    
    weak var delegate: MessageComposeViewControllerDelegateProtocol?
    
    private override init() {
        //
    }
    
    func sendMessage(recipients: [String], body: String, messageComposeViewController: MessageComposeViewControllerProtocol = MFMessageComposeViewControllerWrapper()) {
        if !type(of: messageComposeViewController).canSendText() {
            print("Can not send message with this device")
            return //EXIT
        }
        messageComposeViewController.recipients = recipients
        messageComposeViewController.body = body
        messageComposeViewController.messageComposeDelegate = self

        MessageHelper.getRootViewController()?.present(messageComposeViewController, animated: true, completion: nil)
    }
    
    
    // from MFMessageComposeViewControllerDelegate protocol
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        delegate?.messageComposeViewController(controller, didFinishWith: result)
        MessageHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window??.rootViewController
    }
    
}
