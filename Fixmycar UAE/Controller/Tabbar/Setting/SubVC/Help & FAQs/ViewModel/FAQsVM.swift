//
//  FAQsVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class FAQsVM {
    
    var successFaqs: (() -> Void)?
    var failuerFaqs: ((String?) -> Void)?
    
    var faqs: [FAQ] = []
    var category: String = ""
    
    func getFaqs() {
        let pathCom = "?" + "category=driver"
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.faqs,
            pathComponent: pathCom,
            responseType: FAQResponse.self,
            parameterEncoding: .url
        ) { [weak self] response, errorMessage, statusCode in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // 1️⃣ Network / APIClient error
                if let errorMessage = errorMessage {
                    debugPrint("❌ APIClient Error:", errorMessage)
                    debugPrint("❌ Status Code:", statusCode ?? 0)
                    self.failuerFaqs?(errorMessage)
                    return
                }
                
                // 2️⃣ No response
                guard let response = response else {
                    self.failuerFaqs?("Empty response")
                    return
                }
                
                // 3️⃣ API status false
                guard response.status else {
                    self.failuerFaqs?(response.message)
                    return
                }
                
                // 4️⃣ Success
                guard let data = response.data else {
                    self.failuerFaqs?("No data found")
                    return
                }
                
                self.faqs = data.faqs ?? []
                self.category = data.category ?? ""
                
                self.successFaqs?()
            }
        }
    }
}
