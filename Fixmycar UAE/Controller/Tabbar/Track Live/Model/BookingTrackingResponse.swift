//
//  BookingTrackingResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 19/02/26.
//

import Foundation

// MARK: - Main Response
struct BookingTrackingResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BookingTrackingData?
    let errors: String?
}

// MARK: - Data
struct BookingTrackingData: Codable {
    let bookingID: Int?
    let status: String?
    let pickupAddress: Address?
    let dropAddress: Address?
    let vehicleNumber: String?
    let vehicleType: String?
    let driver: TrackLiveDriver?
    let distanceKm: Double?
    let finalPrice: Double?
    let paymentType: String?
    let paymentSummary: PaymentSummary?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case status
        case pickupAddress = "pickup_address"
        case dropAddress = "drop_address"
        case vehicleNumber = "vehicle_number"
        case vehicleType = "vehicle_type"
        case driver
        case distanceKm = "distance_km"
        case finalPrice = "final_price"
        case paymentType = "payment_type"
        case paymentSummary = "payment_summary"
    }
}

// MARK: - Payment Summary
struct PaymentSummary: Codable {
    let paymentStatus: String?
    let totalAmount: Double?
    let paidAmount: Double?
    let remainingAmount: Double?

    enum CodingKeys: String, CodingKey {
        case paymentStatus = "payment_status"
        case totalAmount = "total_amount"
        case paidAmount = "paid_amount"
        case remainingAmount = "remaining_amount"
    }
}

// MARK: - Address
struct Address: Codable {
    let address: String?
    let lat: Double?
    let lng: Double?
}

// MARK: - Driver
struct TrackLiveDriver: Codable {
    let id: Int?
    let name: String?
    let phone: String?
    let image: String?
    let rating: Double?
    let location: TrackLiveDriverLocation?
    let country_code: String?
}

// MARK: - Driver Location
struct TrackLiveDriverLocation: Codable {
    let lat: Double?
    let lng: Double?
    let heading: Double?
}
