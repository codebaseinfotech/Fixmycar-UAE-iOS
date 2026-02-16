//
//  BookingResponseModel.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

import Foundation

// MARK: - Main Response
struct BookingResponseModel: Codable {
    let status: Bool?
    let message: String?
    let data: BookingData?
    let errors: String?
}

// MARK: - Booking Data
struct BookingData: Codable {
    let bookingId: Int?
    let status: String?
    let priceBreakdown: PriceBreakdown?
    let details: CreateBookingDetails?
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case status
        case priceBreakdown = "price_breakdown"
        case details
    }
}

// MARK: - Price Breakdown
struct PriceBreakdown: Codable {
    let basePrice: Double?
    let discountAmount: Double?   // ✅ Changed to Double
    let finalPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case discountAmount = "discount_amount"
        case finalPrice = "final_price"
        case currency
    }
}

// MARK: - Booking Details
struct CreateBookingDetails: Codable {
    let customerId: Int?
    let serviceTypeId: Int?
    let promotionId: Int?   // ✅ Nullable supported
    let pickupAddress: String?
    let pickupLat: Double?
    let pickupLng: Double?
    let dropoffAddress: String?
    let dropoffLat: Double?
    let dropoffLng: Double?
    let distanceKm: Double?   // ✅ Handles 0 or decimal
    let basePrice: Double?
    let estimatedPrice: Double?
    let discountAmount: Double?   // ✅ Changed to Double
    let finalPrice: Double?
    let bookingType: String?
    let scheduledAt: String?
    let status: String?
    let paymentStatus: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?
    let promotionCode: String?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case serviceTypeId = "service_type_id"
        case promotionId = "promotion_id"
        case pickupAddress = "pickup_address"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case dropoffAddress = "dropoff_address"
        case dropoffLat = "dropoff_lat"
        case dropoffLng = "dropoff_lng"
        case distanceKm = "distance_km"
        case basePrice = "base_price"
        case estimatedPrice = "estimated_price"
        case discountAmount = "discount_amount"
        case finalPrice = "final_price"
        case bookingType = "booking_type"
        case scheduledAt = "scheduled_at"
        case status
        case paymentStatus = "payment_status"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case promotionCode = "promotion_code"
    }
}
