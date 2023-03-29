//
//  SharedMethods.swift
//  Guardian
//
//  Created by Siyu Yao on 03/01/2023.
//

import UIKit

@objc class SharedMethods: NSObject {
    static var dateFormatter = DateFormatter()
    
    @objc  class func showMessage(_ title: String?, message msg: String?, onVC vc: UIViewController?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
            alert.dismiss(animated: true) {() -> Void in }
        })
        alert.addAction(cancel)
        vc?.present(alert, animated: true) {() -> Void in }
    }
    
    class func showMessageWithOKActionBtn(_ title: String?, message msg: String?, OKMessage: String, onVC vc: UIViewController?, proceedAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: OKMessage, style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in proceedAction()})
        alert.addAction(ok)
        vc?.present(alert, animated: true) {() -> Void in }
    }
    
    class func showMessageWith2Buttons(_ title: String?, message msg: String?,cancelMsg: String, OKMessage: String, onVC vc: UIViewController?, proceedAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: cancelMsg, style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
            alert.dismiss(animated: true) {() -> Void in }
        })
        alert.addAction(cancel)
        alert.addAction(UIAlertAction(title: OKMessage, style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in proceedAction()}))
        vc?.present(alert, animated: true) {() -> Void in }
    }
    
    func showSettingsAlertController(title: String, message: String,onVC vc: UIViewController?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    //This method is used to convert jsonstring to dictionary [String:Any]
    func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: Any]
    }
    
    class func dateToStringConverter(date:Date) ->String{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        let timeString = dateFormatter.string(from: date)
        return timeString
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
