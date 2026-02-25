//
//  ChatVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 24/02/26.
//

import Foundation

class ChatVM {
    var successChatList: (() -> Void)?
    var failureChatList: ((String) -> Void)?
    
    var chatList: [InboxItem] = []
    
    func getChatList() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.chat_list,
            responseType: InboxResponse.self,
            parameterEncoding: .url) { response, error, statusCode in
                // 🔴 If error
                if let error = error {
                    self.failureChatList?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureChatList?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureChatList?(response.message ?? "Failed")
                    return
                }
                
                self.chatList = response.data ?? []
                self.successChatList?()
            }
    }
    
}
