//
//  LegalInfoVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class LegalInfoVM {
 
    var successLegalInfo: (() -> Void)?
    var failureLegalInfo: ((String) -> Void)?
    
    var legalInfoData: LegalInfoData?
    
    func legalInfo(screen: LegalInfoAll) {
        
        let endpoint: APIEndPoint
        
        switch screen {
        case .termsAndConditions:
            endpoint = .terms
        case .privacyPolicy:
            endpoint = .privacy
        case .aboutUs:
            endpoint = .about
        }
        
        let pathCom = "?" + "type=" + "customer"
        
        APIClient.sharedInstance.request(
            method: .get,
            url: endpoint,
            pathComponent: pathCom,
            needUserToken: true,
            responseType: LegalInfoResponse.self,
            parameterEncoding: .url
        ) { [weak self] response, errorMessage, statusCode in
            
            DispatchQueue.main.async {
                guard let self else { return }
                
                if let errorMessage = errorMessage {
                    debugPrint("❌ API Error:", errorMessage)
                    self.failureLegalInfo?(errorMessage)
                    return
                }
                
                guard let response else {
                    self.failureLegalInfo?("Empty response")
                    return
                }
                
                guard response.status else {
                    self.failureLegalInfo?(response.message)
                    return
                }
                
                guard let data = response.data else {
                    self.failureLegalInfo?("No data found")
                    return
                }
                
                self.legalInfoData = data
                self.successLegalInfo?()
            }
        }
    }
}
