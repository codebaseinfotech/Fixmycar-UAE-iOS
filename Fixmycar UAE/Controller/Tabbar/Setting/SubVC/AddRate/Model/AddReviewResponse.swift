//
//  AddReviewResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 06/03/26.
//

import Foundation

struct AddReviewResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ReviewData?
}

struct ReviewData: Codable {
    let id: Int?
    let bookingID: Int?
    let customerID: Int?
    let driverID: Int?
    let rating: Int?
    let review: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingID = "booking_id"
        case customerID = "customer_id"
        case driverID = "driver_id"
        case rating
        case review
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
