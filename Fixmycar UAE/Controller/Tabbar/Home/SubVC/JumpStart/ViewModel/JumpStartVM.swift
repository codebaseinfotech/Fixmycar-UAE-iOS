//
//  JumpStartVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class JumpStartVM {
    var successGetSupportDetails: (() -> Void)?
    var failuerGetSupportDetails: ((String?) -> Void)?

    var supportDetails: SupportDetailsData?

    // MARK: - Get Support Details API
    func getSupportDetails() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.support,
            responseType: SupportDetailsResponse.self,
            parameterEncoding: .url
        ) { [weak self] response, errorMessage, statusCode in

            DispatchQueue.main.async {
                guard let self = self else { return }

                // 1️⃣ Network / APIClient error
                if let errorMessage = errorMessage {
                    debugPrint("❌ APIClient Error:", errorMessage)
                    debugPrint("❌ Status Code:", statusCode ?? 0)
                    self.failuerGetSupportDetails?(errorMessage)
                    return
                }

                // 2️⃣ No response
                guard let response = response else {
                    self.failuerGetSupportDetails?("Empty response")
                    return
                }

                // 3️⃣ API status false
                guard response.status else {
                    self.failuerGetSupportDetails?(response.message)
                    return
                }

                // 4️⃣ Success
                guard let data = response.data else {
                    self.failuerGetSupportDetails?("No data found")
                    return
                }

                self.supportDetails = data
                self.successGetSupportDetails?()
            }
        }
    }
}
