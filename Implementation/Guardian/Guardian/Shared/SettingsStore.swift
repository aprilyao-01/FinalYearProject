//
//  SettingsStore.swift
//  Guardian
//
//  Created by Siyu Yao on 26/01/2023.
//

import Foundation

@objcMembers public class SettingsStore: NSObject  {
    var appPIN = "1234"
    var currentUserId = "CU_001"

    private static var settingsStore : SettingsStore = {
        let settings = SettingsStore()
        return settings
    }()
    
    @objc class func shared() -> SettingsStore {
        return settingsStore
    }
    
}
