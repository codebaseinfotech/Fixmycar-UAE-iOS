//
//  ChatDetailsVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 26/02/26.
//

import Foundation

class ChatDetailsVM {
    var successChatDetails: (()->Void)?
    var failureChatDetails: ((String)->Void)?
    
    var successSendMessage: (()->Void)?
    var failureSendMessage: ((String)->Void)?
    
    var messageList: [MessageDetails] = []
    
    var jobId: Int?
    var message: String?
    
    func getChatDetails() {
        let pathComponents = "/" + "\(jobId ?? 0)"
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.chatDetails,
            pathComponent: pathComponents,
            responseType: MessagesResponse.self,
            parameterEncoding: .url) { response, error, statusCode in
                // 🔴 If error
                if let error = error {
                    self.failureChatDetails?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureChatDetails?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureChatDetails?(response.message ?? "Failed")
                    return
                }
                self.messageList = response.data?.messages ?? []
                self.successChatDetails?()
            }
    }
    
    func sendMessageOnChat() {
        let param: [String: Any] = [
            "job_id": jobId ?? 0,
            "message_type": "text",
            "message": message ?? ""
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.sendMessage,
            parameters: param,
            responseType: SendMessageResponse.self,
            parameterEncoding: .json) { response, error, statusCode in
                // 🔴 If error
                    if let error = error {
                        self.failureSendMessage?(error)
                        return
                    }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureSendMessage?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureSendMessage?(response.message ?? "Failed")
                    return
                }
                self.successSendMessage?()
            }
    }
    
}
