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
    
    private override init() {
        //
    }
    
    func sendMessage(recipients:[String], body:String){
        if !MFMessageComposeViewController.canSendText() {
            print("Can not send message with this device")
            return //EXIT
        }
        let picker = MFMessageComposeViewController()
        picker.recipients = recipients
        picker.body = body
        picker.messageComposeDelegate = self
        
        MessageHelper.getRootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    
    // from MFMessageComposeViewControllerDelegate protocol
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        MessageHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window??.rootViewController
    }
    
}
