//
//  BookingDetailsResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

// MARK: - BookingDetailsResponse
struct BookingDetailsResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BookingDetails?
    let errors: String?
}

// MARK: - BookingDetails
struct BookingDetails: Codable {
    
    let id: Int?
    let bookingId: Int?
    let status: String?
    let paymentStatus: String?
    let createdAt: String?
    let serviceType: String?
    
    let pickupAddress: String?
    let pickupLat: String?
    let pickupLng: String?
    
    let dropoffAddress: String?
    let dropoffLat: String?
    let dropoffLng: String?
    
    let distanceKm: String?
    let basePrice: Double?
    let discountAmount: Double?
    
    let platformFee: Double?
    let tax: Double?
    let taxPercentage: Double?
    
    let finalPrice: Double?
    let currency: String?
    
    let driver: Driver?
    
    let acceptedAt: String?
    let arrivedAt: String?
    let startedAt: String?
    let completedAt: String?
    let cancelledAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case status
        case paymentStatus = "payment_status"
        case createdAt = "created_at"
        case serviceType = "service_type"
        
        case pickupAddress = "pickup_address"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        
        case dropoffAddress = "dropoff_address"
        case dropoffLat = "dropoff_lat"
        case dropoffLng = "dropoff_lng"
        
        case distanceKm = "distance_km"
        case basePrice = "base_price"
        case discountAmount = "discount_amount"
        
        case platformFee = "platform_fee"
        case tax
        case taxPercentage = "tax_percentage"
        
        case finalPrice = "final_price"
        case currency
        
        case driver
        
        case acceptedAt = "accepted_at"
        case arrivedAt = "arrived_at"
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case cancelledAt = "cancelled_at"
    }
}

struct Driver: Codable {
    
    let id: Int?
    let name: String?
    let rating: String?
    let vehicleModel: String?
    let vehicleNumber: String?
    let image: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rating
        case vehicleModel = "vehicle_model"
        case vehicleNumber = "vehicle_number"
        case image
        case phone
    }
}

