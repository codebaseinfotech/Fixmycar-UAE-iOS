//
//  BookingHistoryResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

// MARK: - BookingHistoryResponse
struct BookingHistoryResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BookingHistoryData?
    let errors: String?
}

// MARK: - BookingHistoryData
struct BookingHistoryData: Codable {
    let data: [BookingItem]?
    let links: PaginationLinks?
    let meta: PaginationMeta?
}


// MARK: - BookingItem
// MARK: - BookingItem
struct BookingItem: Codable {
    let id: Int?
    let bookingID: Int?
    let serviceType: String?
    let status: String?
    let createdAt: String?
    let pickupAddress: String?
    let dropoffAddress: String?
    let totalAmount: Double?
    let baseAmount: Double?
    let discountAmount: Double?
    let tax: Double?
    let promotionCode: String?
    let additionalNotes: String?
    let currency: String?
    let isRated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingID = "booking_id"
        case serviceType = "service_type"
        case status
        case createdAt = "created_at"
        case pickupAddress = "pickup_address"
        case dropoffAddress = "dropoff_address"
        case totalAmount = "total_amount"
        case baseAmount = "base_amount"
        case discountAmount = "discount_amount"
        case tax
        case promotionCode = "promotion_code"
        case additionalNotes = "additional_notes"
        case currency
        case isRated = "is_rated"
    }
}

// MARK: - PaginationLinks
struct PaginationLinks: Codable {
    let first: String?
    let last: String?
    let prev: String?
    let next: String?
}

// MARK: - PaginationMeta
struct PaginationMeta: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let links: [MetaLink]?
    let path: String?
    let perPage: Int?
    let to: Int?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links
        case path
        case perPage = "per_page"
        case to
        case total
    }
}

// MARK: - MetaLink
struct MetaLink: Codable {
    let url: String?
    let label: String?
    let page: Int?
    let active: Bool?
}
