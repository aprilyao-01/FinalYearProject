//
//  SharedMethods.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import UIKit

@objc class SharedMethods: NSObject {
    
    @objc  class func showMessage(_ title: String?, message msg: String?, onVC vc: UIViewController?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
            alert.dismiss(animated: true) {() -> Void in }
        })
        alert.addAction(cancel)
        vc?.present(alert, animated: true) {() -> Void in }
    }
    
    //This method is used to convert jsonstring to dictionary [String:Any]
    func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: Any]
    }
    
}

extension UIApplication {
    
    @objc class func topViewController(viewController: UIViewController? = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first!.rootViewController) -> UIViewController? {
            
            if let nav = viewController as? UINavigationController {
                return topViewController(viewController: nav.visibleViewController)
            }
            if let tab = viewController as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(viewController: selected)
                }
            }
            if let presented = viewController?.presentedViewController {
                return topViewController(viewController: presented)
            }
            return viewController
        }
}
