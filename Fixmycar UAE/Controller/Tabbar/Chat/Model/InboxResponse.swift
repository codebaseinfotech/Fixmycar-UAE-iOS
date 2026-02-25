//
//  InboxResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

// MARK: - InboxResponse
class InboxResponse: Codable {
    var status: Bool?
    var message: String?
    var data: [InboxItem]?
    var errors: String?
}

// MARK: - InboxItem
class InboxItem: Codable {
    var jobId: Int?
    var chatPartner: String?
    var partnerImage: String?
    var jobStatus: String?
    var lastMessage: String?
    var lastMessageTime: String?
    var unreadCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case chatPartner = "chat_partner"
        case partnerImage = "partner_image"
        case jobStatus = "job_status"
        case lastMessage = "last_message"
        case lastMessageTime = "last_message_time"
        case unreadCount = "unread_count"
    }
}
