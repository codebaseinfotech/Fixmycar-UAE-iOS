//
//  AddRateVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 06/03/26.
//

import Foundation
import OneSignal

class AddRateVM {
    var successRate: (() -> Void)?
    var failureRate: ((String) -> Void)?
    
    var rating: Int?
    var review: String?
    
    var notificationPayload: OSNotificationPayload?
    var bookingId: Int?
    
    func addRate() {
        let bookingId = bookingId != 0 ? bookingId ?? 0 : notificationPayload?.bookingId ?? 0
        let pathComponet = "/" + "\(bookingId)" + "/" + "review"
        let params: [String: Any] = [
            "rating": rating ?? 0,
            "review": review ?? ""
        ]
        
        debugPrint("rateing param", params)
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.bookingList,
            parameters: params,
            pathComponent: pathComponet,
            responseType: AddReviewResponse.self) { [weak self] response, errorMessage, statusCode in
                
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    if let errorMessage = errorMessage {
                        debugPrint("❌ API Error:", errorMessage)
                        self.failureRate?(errorMessage)
                        return
                    }
                    
                    guard let response else {
                        self.failureRate?("Empty response")
                        return
                    }
                    
                    guard response.status == true else {
                        self.failureRate?(response.message ?? "")
                        return
                    }
                    
                    guard let data = response.data else {
                        self.failureRate?("No data found")
                        return
                    }
                    
                    self.successRate?()
                }
            }
    }
}
