//
//  MyProfileVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 19/02/26.
//

import Foundation

class MyProfileVM {
    var successGetProfile: (() -> Void)?
    var failureGetProfile: ((String) -> Void)?
    
    func getProfile() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.updateProfile,
            responseType: LoginSuccessResponseModel.self,
            parameterEncoding: .url) { [self] response, errorMessage, statusCode in
                APIClient.sharedInstance.hideIndicator()
                
                if let response = response {
                    debugPrint("SUCCESS:", response.message ?? "")
                    
                    let message = response.message
                    if statusCode == 200 {
                        if response.status == true {
                            FCUtilites.saveCurrentUser(response.data?.user)
                            successGetProfile?()
                        } else {
                            failureGetProfile?(message ?? "")
                        }
                    } else {
                        failureGetProfile?(message ?? "")
                    }
                    
                } else {
                    debugPrint("ERROR:", errorMessage ?? "")
                    failureGetProfile?(errorMessage ?? "")
                }
            }
    }
    
}
