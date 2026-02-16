//
//  SupportDetailsResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

// MARK: - SupportDetailsResponse
struct SupportDetailsResponse: Codable {
    let status: Bool
    let message: String
    let data: SupportDetailsData?
    let errors: String?
}

// MARK: - SupportDetailsData
struct SupportDetailsData: Codable {
    let chatSupportEnabled: Bool
    let phoneNumber: String
    let email: String
    let availabilityHours: String

    enum CodingKeys: String, CodingKey {
        case chatSupportEnabled = "chat_support_enabled"
        case phoneNumber = "phone_number"
        case email
        case availabilityHours = "availability_hours"
    }
}
