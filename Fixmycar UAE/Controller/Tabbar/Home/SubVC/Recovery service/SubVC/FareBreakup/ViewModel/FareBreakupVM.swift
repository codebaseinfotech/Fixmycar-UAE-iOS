//
//  FareBreakupVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 25/02/26.
//

import Foundation

class FareBreakupVM {
    var successPromoCode: (() -> Void)?
    var failurePromoCode: ((String) -> Void)?
    
    var promoCodeData: PromoCodeData?
    
    func getPromoCode(promoCode: String) {
        
        let params: [String: Any] = [
            "code": promoCode
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.promo_code_verify,
            parameters: params,
            needUserToken: true,
            responseType: PromoCodeResponse.self) { response, error, statusCode in
                // 🔴 If error
                if let error = error {
                    self.failurePromoCode?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failurePromoCode?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failurePromoCode?(response.message ?? "Failed")
                    return
                }
                
                self.promoCodeData = response.data
                self.successPromoCode?()
            }
    }
}
