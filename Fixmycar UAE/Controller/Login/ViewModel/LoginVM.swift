//
//  LoginVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
//

import Foundation

class LoginVM {
    
    var successLogin: (()->Void)?
    var failureLogin: ((String)->Void)?
    
    var loginResponse: OTPResponseModel?
    
    func callLoginAPI(phone: String, countryCode: String) {
        
        let params: [String: Any] = [
            "phone": phone,
            "country_code": countryCode
        ]
        
        APIClient.sharedInstance.showIndicaor()
        
        APIClient.sharedInstance.request(
            method: .post,
            url: .loginUser,
            parameters: params,
            needUserToken: false,
            responseType: OTPResponseModel.self,
            parameterEncoding: .json
        ) { [weak self] response, error, statusCode in
            
            APIClient.sharedInstance.hideIndicator()
            
            guard let self = self else { return }
            
            if let error = error {
                self.failureLogin?(error)
                return
            }
            
            guard let response = response else {
                self.failureLogin?("Something went wrong")
                return
            }
            
            if response.status == true {
                self.loginResponse = response
                self.successLogin?()
            } else {
                self.failureLogin?(response.message ?? "")
            }
        }
    }
    
    
}

struct ModifyLastLoginResponse: Codable {
    let status: Bool
    let message: String?
    let data: LastLoginData?
    let errors: [String: [String]]?
}

struct LastLoginData: Codable {
    let lastLoggedinAt: String
    let lastLoginAt: String

    enum CodingKeys: String, CodingKey {
        case lastLoggedinAt = "last_loggedin_at"
        case lastLoginAt = "last_login_at"
    }
}
