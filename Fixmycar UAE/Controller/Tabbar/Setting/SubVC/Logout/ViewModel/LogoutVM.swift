//
//  LogoutVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class LogoutVM {
    
    var successLogout: (()->Void)?
    var selectedDeleteReason: String?
    
    var successDeleteAccount: (()->Void)?
    var failureDeleteAccount: ((String)->Void)?
    
    func logoutUser() {
        APIClient.sharedInstance.showIndicaor()
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.logoutUser,
            needUserToken: true,
            responseType: LogoutResponse.self) { [self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                
                let _ = response?.message ?? ""
                if statusCode == 200 {
                    if let status = response?.status, status {
                        FCUtilites.saveCurrentUserToken("")
                        FCUtilites.saveIsGetCurrentUser(false)
                        FCUtilites.saveRoleName("")
                        FCUtilites.saveCurrentUser(nil)
                        successLogout?()
                    } else {
                        FCUtilites.saveCurrentUserToken("")
                        FCUtilites.saveIsGetCurrentUser(false)
                        FCUtilites.saveRoleName("")
                        FCUtilites.saveCurrentUser(nil)

                        successLogout?()
                    }
                } else {
                    FCUtilites.saveCurrentUserToken("")
                    FCUtilites.saveIsGetCurrentUser(false)
                    FCUtilites.saveRoleName("")
                    FCUtilites.saveCurrentUser(nil)

                    successLogout?()
                }
            }
    }
    
    // MARK: - Delete Account API
    func deleteUser() {
        APIClient.sharedInstance.showIndicaor()
        
        let pathComponet = "?" + "reason=" + (selectedDeleteReason ?? "")
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.deleteAccount,
            pathComponent: pathComponet,
            needUserToken: true,
            responseType: LogoutResponse.self) { [self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                
                let _ = response?.message ?? ""
                if statusCode == 200 {
                    if let status = response?.status, status {
                        
                        FCUtilites.saveCurrentUserToken("")
                        FCUtilites.saveIsGetCurrentUser(false)
                        FCUtilites.saveRoleName("")
                        FCUtilites.saveCurrentUser(nil)
                        
                        successDeleteAccount?()
                    } else {
                        failureDeleteAccount?(error ?? "")
                    }
                } else {
                    failureDeleteAccount?(error ?? "")
                }
            }
    }
    
}
