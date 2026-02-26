//
//  MessagesResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 26/02/26.
//

import Foundation

// MARK: - Main Response
struct MessagesResponse: Codable {
    let status: Bool?
    let message: String?
    let data: MessagesData?
    let errors: String?
}

// MARK: - Data
struct MessagesData: Codable {
    let messages: [MessageDetails]?
    let pagination: Pagination?
}

// MARK: - Message
struct MessageDetails: Codable {
    let id: Int?
    let job_id: Int?
    let sender_id: Int?
    let sender_name: String?
    let sender_role: String?
    let message_type: String?
    let message: String?
    let attachment_url: String?
    let is_read: Bool?
    let read_at: String?
    let created_at: String?
    let is_me: Bool?
}


// MARK: - Pagination
struct Pagination: Codable {
    let total: Int?
    let count: Int?
    let per_page: Int?
    let current_page: Int?
    let total_pages: Int?
}
