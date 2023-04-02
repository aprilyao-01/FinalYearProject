//
//  ActivityIndicator.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation
import UIKit

class ActivityIndicator: NSObject {
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var view: UIView!
    
    func showActivityIndicator() {
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first  else { return }
        view = window
        
        view.isUserInteractionEnabled = false
        activityIndicator.removeFromSuperview()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor(red: 0.04, green: 0.38, blue: 0.60, alpha: 1.00)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if self.view == nil {
                return
            }
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.removeFromSuperview()
        }
    }
}
