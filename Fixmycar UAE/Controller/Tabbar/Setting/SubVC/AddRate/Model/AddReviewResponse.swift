//
//  AddReviewResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 06/03/26.
//

import Foundation

struct AddReviewResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ReviewData?
}

struct ReviewData: Codable {
    let bookingId: Int?
    let customerId: Int?
    let driverId: Int?
    let rating: Int?
    let review: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case customerId = "customer_id"
        case driverId = "driver_id"
        case rating
        case review
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
