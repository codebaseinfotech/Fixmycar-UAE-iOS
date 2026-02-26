//
//  SendMessageResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 26/02/26.
//

import Foundation

// MARK: - Send Message Response
struct SendMessageResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ChatMessage?
    let errors: String?   // safest
}

struct ChatMessage: Codable {
    let id: Int?
    let jobId: Int?
    let senderId: Int?
    let senderName: String?
    let senderRole: String?
    let messageType: String?
    let message: String?
    let attachmentURL: String?
    let isRead: Bool?
    let readAt: String?
    let createdAt: String?
    let isMe: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case senderId = "sender_id"
        case senderName = "sender_name"
        case senderRole = "sender_role"
        case messageType = "message_type"
        case message
        case attachmentURL = "attachment_url"
        case isRead = "is_read"
        case readAt = "read_at"
        case createdAt = "created_at"
        case isMe = "is_me"
    }
}
