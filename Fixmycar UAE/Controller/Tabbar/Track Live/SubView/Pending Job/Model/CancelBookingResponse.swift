//
//  CancelBookingResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 03/03/26.
//

import Foundation

struct CancelBookingResponse: Codable {
    let status: Bool?
    let message: String?
    let data: CancelBookingData?
    let errors: String?
}

struct CancelBookingData: Codable {
    let bookingId: Int?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case status
    }
}
