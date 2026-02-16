//
//  FeedbackVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class FeedbackVM {
    
    var successFeedback: ((String) -> Void)?
    var failuerFeedback: ((String) -> Void)?
    
    func submitFeedback(
        fullName: String,
        email: String,
        subject: String,
        message: String
    ) {
        
        let params = [
            "full_name": fullName,
            "email": email,
            "subject": subject,
            "message": message
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: .feedback,
            parameters: params,
            needUserToken: true,
            responseType: FeedbackResponse.self,
            parameterEncoding: .json
        ) { [weak self] response, errorMessage, statusCode in
            
            guard let self = self else { return }
            
            if let errorMessage = errorMessage {
                self.failuerFeedback?(errorMessage)
                return
            }
            
            guard let response = response else {
                self.failuerFeedback?("Something went wrong")
                return
            }
            
            if response.status {
                self.successFeedback?(response.message)
            } else {
                self.failuerFeedback?(response.message)
            }
        }
    }
    
}
