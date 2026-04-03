//
//  CreateAccountVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
//

import Foundation
import OneSignal

class CreateAccountVM {
    
    var successRegister: (() -> Void)?
    var failureRegister: ((String) -> Void)?
    
    var registerResponse: LoginSuccessData?
    
    func callRegisterAPI(
        phone: String,
        firstName: String,
        lastName: String,
        email: String,
        referralCode: String,
        countryCode: String
    ) {
        
        let params: [String: Any] = [
            "phone": phone,
            "first_name": firstName,
            "last_name": "",
            "email": email,
            "referral_code": referralCode,
            "country_code": countryCode
        ]
        
        APIClient.sharedInstance.showIndicaor()
        
        APIClient.sharedInstance.request(
            method: .post,
            url: .register,
            parameters: params,
            needUserToken: false,
            responseType: LoginSuccessResponseModel.self,
            parameterEncoding: .json
        ) { [weak self] response, errorMessage, statusCode in
            
            APIClient.sharedInstance.hideIndicator()
            guard let self = self else { return }
            
            if statusCode == 200 {
                if response?.status == true {
                    
                    self.registerResponse = response?.data
                    
                    // ✅ Save token & user again (API gives new token)
                    FCUtilites.saveCurrentUserToken(response?.data?.accessToken ?? "")
                    FCUtilites.saveIsGetCurrentUser(true)
                    FCUtilites.saveRoleName(response?.data?.roleName ?? "")
                    FCUtilites.saveCurrentUser(response?.data?.user)

                    // Set OneSignal external user ID for push notifications
                    if let userId = response?.data?.user?.id {
                        OneSignal.setExternalUserId("\(userId)")
                    }

                    self.successRegister?()
                    
                } else {
                    self.failureRegister?(errorMessage ?? "")
                }
            } else {
                self.failureRegister?(errorMessage ?? "")
            }
        }
    }
    
}
