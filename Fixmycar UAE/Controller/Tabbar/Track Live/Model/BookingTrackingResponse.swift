//
//  BookingTrackingResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 19/02/26.
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
    let rating: Double?
    let location: TrackLiveDriverLocation?
}

// MARK: - Driver Location
struct TrackLiveDriverLocation: Codable {
    let lat: Double?
    let lng: Double?
    let heading: Double?
}
