//
//  VerifyOtpVM.swift
//  Fixmycar UAE
//
//  Created by iMac on 28/01/26.
//

import Foundation

class VerifyOtpVM {
    
    var successVerify: (() -> Void)?
    var failureVerify: ((String) -> Void)?
    
    var verifyResponse: LoginSuccessData?
    var phoneNumber: String = ""
    func callVerifyOtpAPI(phone: String, otp: String, countryCode: String) {
        
        let params: [String: Any] = [
            "phone": phone,
            "otp": otp,
            "country_code": countryCode
        ]
        
        APIClient.sharedInstance.showIndicaor()
        
        APIClient.sharedInstance.request(
            method: .post,
            url: .verifyOtp,
            parameters: params,
            needUserToken: false,
            responseType: LoginSuccessResponseModel.self,
            parameterEncoding: .json
        ) { [self] response, errorMessage, statusCode in
            APIClient.sharedInstance.hideIndicator()
            
            if statusCode == 200 {
                verifyResponse = response?.data

                if response?.status == true {
                    if response?.data?.isRegistered == true {
                        FCUtilites.saveCurrentUserToken(response?.data?.accessToken ?? "")
                        FCUtilites.saveIsGetCurrentUser(true)
                        FCUtilites.saveRoleName(response?.data?.roleName ?? "")
                        FCUtilites.saveCurrentUser(response?.data?.user)
                    }
                    
                    successVerify?()
                } else {
                    failureVerify?(response?.message ?? "")
                }
            } else {
                failureVerify?(response?.message ?? "")
            }
        }
    }
}
