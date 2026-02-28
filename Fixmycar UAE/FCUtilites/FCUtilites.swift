//
//  FCUtilites.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
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
    
    class func saveCurrentUserToken(_ access_token: String) {
        userDefaults.set(access_token, forKey: "access_token")
    }
    
    class func getCurrentUserToken() -> String {
        return userDefaults.string(forKey: "access_token") ?? ""
    }
    
    class func saveCurrentUser(_ user: User?) {
        userDefaults.set(try? PropertyListEncoder().encode(user), forKey: "currentUser")
    }
    
    class func getCurrentUser() -> User? {
        if let data = userDefaults.value(forKey: "currentUser") as? Data {
            return try? PropertyListDecoder().decode(User.self, from: data)
        }
        return nil
    }
    
    class func saveRoleName(_ role: String) {
        userDefaults.set(role, forKey: "role_name")
    }
    
    class func getRoleName() -> String {
        return userDefaults.string(forKey: "role_name") ?? ""
    }
    
    class func saveOneSignleToken(_ token: String) {
        userDefaults.set(token, forKey: "onesignle_token")
    }
    
    class func getOneSignleToken() -> String {
        userDefaults.string(forKey: "onesignle_token") ?? ""
    }
    
    // MARK: - getdevice
    class func deviceType() -> String {
        return "iOS"
    }
    
    class func deviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
