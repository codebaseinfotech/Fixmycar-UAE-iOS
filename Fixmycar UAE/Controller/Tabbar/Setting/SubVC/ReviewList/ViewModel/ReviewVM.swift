//
//  ReviewVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 09/03/26.
//

import Foundation

class ReviewVM {
    var successReviewList: (() -> Void)?
    var failureReviewList: ((String) -> Void)?
    
    var reviewSummery: ReviewSummary?
    var reviewList: [ReviewListData] = []
    
    func getReviewList() {
        let pathComponet = "?" + "type=my_customer_reviews"
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.reviewList,
            pathComponent: pathComponet,
            responseType: ReviewResponseModel.self,
            parameterEncoding: .url) { [weak self] response, errorMessage, statusCode in
                // 1️⃣ Network / APIClient error
                if let errorMessage = errorMessage {
                    debugPrint("❌ APIClient Error:", errorMessage)
                    debugPrint("❌ Status Code:", statusCode ?? 0)
                    self?.failureReviewList?(errorMessage)
                    return
                }
                // 2️⃣ No response
                guard let response = response else {
                    self?.failureReviewList?("Empty response")
                    return
                }
                
                // 3️⃣ API status false
                guard response.status == true else {
                    self?.failureReviewList?(response.message ?? "")
                    return
                }
                
                self?.reviewSummery = response.summary
                self?.reviewList = response.data ?? []
                self?.successReviewList?()
            }
    }
}
