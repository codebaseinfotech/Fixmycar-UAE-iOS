//
//  VerifyOtpVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
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
                        
                        self.lastLoginModify(role: FCUtilites.getRoleName())
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
    
    func lastLoginModify(role: String) {
        
        let parameters: [String: Any] = [
            "role": role
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.lastLoginModify,
            parameters: parameters,
            responseType: ModifyLastLoginResponse.self) { [self] response, errorMessage, statusCode in
                
                if let response = response {
                    debugPrint("SUCCESS:", response.message)
                    
                } else {
                    debugPrint("ERROR:", errorMessage ?? "")
                    failureVerify?(errorMessage ?? "")
                }
            }
    }
}
