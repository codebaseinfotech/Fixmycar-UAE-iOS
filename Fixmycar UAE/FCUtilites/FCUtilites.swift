//
//  FCUtilites.swift
//  Fixmycar UAE
//
//  Created by iMac on 28/01/26.
//

import Foundation

class FCUtilites {
    static let userDefaults = UserDefaults.standard

    class func saveIsGetCurrentUser(_ isUserLogin: Bool) {
        userDefaults.set(isUserLogin, forKey: "isUserLogin")
    }
    
    class func getIsCurrentUser() -> Bool {
        return userDefaults.bool(forKey: "isUserLogin")
    }
    
    // MARK: - getdevice
    class func deviceType() -> String {
        return "iOS"
    }
    
    class func deviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
