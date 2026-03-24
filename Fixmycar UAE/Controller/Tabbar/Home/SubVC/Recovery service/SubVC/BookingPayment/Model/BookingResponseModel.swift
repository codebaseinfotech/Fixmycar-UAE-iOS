//
//  BookingResponseModel.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
//

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
    let discountAmount: Double?
    let finalPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case basePrice = "base_price"
        case discountAmount = "discount_amount"
        case finalPrice = "final_price"
        case currency
    }
}

struct CreateBookingDetails: Codable {
    
    let customerId: Int?
    let serviceTypeId: Int?
    let promotionId: Int?
    
    let pickupAddress: String?
    let pickupLat: Double?
    let pickupLng: Double?
    
    let dropoffAddress: String?
    let dropoffLat: Double?
    let dropoffLng: Double?
    
    let polyline: String?
    
    let minutes: Int?
    let tax: Double?
    let platformFee: Double?
    let distanceKm: Double?
    
    let basePrice: Double?
    let estimatedPrice: Double?
    let discountAmount: Double?
    let finalPrice: Double?
    
    let bookingType: String?
    let scheduledAt: String?
    
    let status: String?
    let paymentStatus: String?
    
    let customerVehicleType: String?
    let vehicleIssueId: Int?
    
    let additionalNotes: String?
    
    let vehicleMake: String?
    let vehicleModel: String?
    let vehicalImage: String?
    
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
        case polyline
        case minutes
        case tax
        case platformFee = "platform_fee"
        case distanceKm = "distance_km"
        case basePrice = "base_price"
        case estimatedPrice = "estimated_price"
        case discountAmount = "discount_amount"
        case finalPrice = "final_price"
        case bookingType = "booking_type"
        case scheduledAt = "scheduled_at"
        case status
        case paymentStatus = "payment_status"
        case customerVehicleType = "customer_vehicle_type"
        case vehicleIssueId = "vehicle_issue_id"
        case additionalNotes = "additional_notes"
        case vehicleMake = "vehicle_make"
        case vehicleModel = "vehicle_model"
        case vehicalImage = "vehical_image"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case promotionCode = "promotion_code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        customerId = try? container.decode(Int.self, forKey: .customerId)
        serviceTypeId = try? container.decode(Int.self, forKey: .serviceTypeId)
        promotionId = try? container.decode(Int.self, forKey: .promotionId)
        
        pickupAddress = try? container.decode(String.self, forKey: .pickupAddress)
        pickupLat = container.decodeFlexibleDouble(forKey: .pickupLat)
        pickupLng = container.decodeFlexibleDouble(forKey: .pickupLng)
        
        dropoffAddress = try? container.decode(String.self, forKey: .dropoffAddress)
        dropoffLat = container.decodeFlexibleDouble(forKey: .dropoffLat)
        dropoffLng = container.decodeFlexibleDouble(forKey: .dropoffLng)
        
        polyline = try? container.decode(String.self, forKey: .polyline)
        
        minutes = container.decodeFlexibleInt(forKey: .minutes)
        tax = container.decodeFlexibleDouble(forKey: .tax)
        platformFee = container.decodeFlexibleDouble(forKey: .platformFee)
        distanceKm = container.decodeFlexibleDouble(forKey: .distanceKm)
        
        basePrice = container.decodeFlexibleDouble(forKey: .basePrice)
        estimatedPrice = container.decodeFlexibleDouble(forKey: .estimatedPrice)
        discountAmount = container.decodeFlexibleDouble(forKey: .discountAmount)
        finalPrice = container.decodeFlexibleDouble(forKey: .finalPrice)
        
        bookingType = try? container.decode(String.self, forKey: .bookingType)
        scheduledAt = try? container.decode(String.self, forKey: .scheduledAt)
        
        status = try? container.decode(String.self, forKey: .status)
        paymentStatus = try? container.decode(String.self, forKey: .paymentStatus)
        
        customerVehicleType = try? container.decode(String.self, forKey: .customerVehicleType)
        vehicleIssueId = container.decodeFlexibleInt(forKey: .vehicleIssueId)
        
        additionalNotes = try? container.decode(String.self, forKey: .additionalNotes)
        
        vehicleMake = try? container.decode(String.self, forKey: .vehicleMake)
        vehicleModel = try? container.decode(String.self, forKey: .vehicleModel)
        vehicalImage = try? container.decode(String.self, forKey: .vehicalImage)
        
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        id = try? container.decode(Int.self, forKey: .id)
        
        promotionCode = try? container.decode(String.self, forKey: .promotionCode)
    }
}
