//
//  BookingDetailsResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 11/02/26.
//

import Foundation

// MARK: - Main Response
struct BookingDetailResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BookingDetailData?
    let errors: String?
}

// MARK: - Data
struct BookingDetailData: Codable {
    let id: Int?
    let bookingId: Int?
    let status: String?
    let paymentStatus: String?
    let invoiceURL: String?
    let invoiceNumber: String?
    let createdAt: String?
    
    let serviceType: String?
    let vehicleType: String?
    let issueReported: String?
    let vehicleIssueId: Int?
    let customerNotes: String?
    
    let pickupAddress: String?
    let pickupLat: String?
    let pickupLng: String?
    
    let dropoffAddress: String?
    let dropoffLat: String?
    let dropoffLng: String?
    
    let distanceKm: String?
    let approachDistanceKm: Double?
    let approachDurationSeconds: Int?
    let approachDurationText: String?
    let approachPolyline: String?
    
    let routePolyline: String?
    
    let cancelledBy: String?
    let cancelReasonId: Int?
    let cancelReason: String?
    let cancelReasonText: String?
    
    let isAvalabRating: Bool?
    let driverReview: DriverReview?   // ✅ FIXED HERE
    let driverAverageRating: Double?
    let driverTotalReviews: Int?
    
    let invoice: Invoice?
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
        case invoiceURL = "invoice_url"
        case invoiceNumber = "invoice_number"
        case createdAt = "created_at"
        case serviceType = "service_type"
        case vehicleType = "vehicle_type"
        case issueReported = "issue_reported"
        case vehicleIssueId = "vehicle_issue_id"
        case customerNotes = "customer_notes"
        case pickupAddress = "pickup_address"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case dropoffAddress = "dropoff_address"
        case dropoffLat = "dropoff_lat"
        case dropoffLng = "dropoff_lng"
        case distanceKm = "distance_km"
        case approachDistanceKm = "approach_distance_km"
        case approachDurationSeconds = "approach_duration_seconds"
        case approachDurationText = "approach_duration_text"
        case approachPolyline = "approach_polyline"
        case routePolyline = "route_polyline"
        case cancelledBy = "cancelled_by"
        case cancelReasonId = "cancel_reason_id"
        case cancelReason = "cancel_reason"
        case cancelReasonText = "cancel_reason_text"
        case isAvalabRating = "is_avalab_rating"
        case driverReview
        case driverAverageRating = "driver_average_rating"
        case driverTotalReviews = "driver_total_reviews"
        case invoice
        case driver
        case acceptedAt = "accepted_at"
        case arrivedAt = "arrived_at"
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case cancelledAt = "cancelled_at"
    }
}

// MARK: - Driver Review
struct DriverReview: Codable {
    let id: Int?
    let bookingId: Int?
    let customerId: Int?
    let driverId: Int?
    let rating: Int?
    let review: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case customerId = "customer_id"
        case driverId = "driver_id"
        case rating
        case review
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Invoice
struct Invoice: Codable {
    let baseFare: Double?
    let discount: Double?
    let manual_discount_price: Double?
    let platformFee: Double?
    let tax: Double?
    let totalAmount: Double?
    let taxPercentage: Double?
    let promotionCode: String?
    let currency: String?
    let distanceKm: Double?
    let etaMinutes: Int?
    let bookingDate: String?
    let bookingTime: String?
    let pickupTime: String?
    let dropTime: String?
    let paymentMethod: String?
    let paymentStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case baseFare = "base_fare"
        case discount
        case manual_discount_price
        case platformFee = "platform_fee"
        case tax
        case totalAmount = "total_amount"
        case taxPercentage = "tax_percentage"
        case promotionCode = "promotion_code"
        case currency
        case distanceKm = "distance_km"
        case etaMinutes = "eta_minutes"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case pickupTime = "pickup_time"
        case dropTime = "drop_time"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
    }
}

// MARK: - Driver
struct Driver: Codable {
    let id: Int?
    let name: String?
    let rating: String?
    let vehicleModel: String?
    let vehicleNumber: String?
    let image: String?
    let phone: String?
    let countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rating
        case vehicleModel = "vehicle_model"
        case vehicleNumber = "vehicle_number"
        case image
        case phone
        case countryCode = "country_code"
    }
}
