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
    let errors: [String: [String]]?

    /// Returns a formatted string of all validation errors
    var errorMessage: String? {
        guard let errors = errors, !errors.isEmpty else { return message }
        let allErrors = errors.values.flatMap { $0 }.joined(separator: "\n")
        return allErrors.isEmpty ? message : allErrors
    }
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

// MARK: - Stripe Checkout Response
struct StripeCheckoutResponse: Codable {
    let status: Bool?
    let message: String?
    let data: StripeCheckoutData?
    let errors: [String: [String]]?

    var errorMessage: String? {
        guard let errors = errors, !errors.isEmpty else { return message }
        let allErrors = errors.values.flatMap { $0 }.joined(separator: "\n")
        return allErrors.isEmpty ? message : allErrors
    }
}

struct StripeCheckoutData: Codable {
    let paymentId: Int?
    let serviceRequestId: Int?
    let checkoutSessionId: String?
    let paymentIntentId: String?
    let checkoutUrl: String?
    let successUrl: String?
    let cancelUrl: String?
    let currency: String?
    let amount: Double?
    let status: String?
    let requestedAmount: Double?
    let bookingTotalAmount: Double?
    let alreadyPaidAmount: Double?
    let remainingAmount: Double?
    let isPartialAttempt: Bool?
    let minimumPartialAmount: Double?

    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case serviceRequestId = "service_request_id"
        case checkoutSessionId = "checkout_session_id"
        case paymentIntentId = "payment_intent_id"
        case checkoutUrl = "checkout_url"
        case successUrl = "success_url"
        case cancelUrl = "cancel_url"
        case currency
        case amount
        case status
        case requestedAmount = "requested_amount"
        case bookingTotalAmount = "booking_total_amount"
        case alreadyPaidAmount = "already_paid_amount"
        case remainingAmount = "remaining_amount"
        case isPartialAttempt = "is_partial_attempt"
        case minimumPartialAmount = "minimum_partial_amount"
    }
}

// MARK: - Payment Status Response
struct PaymentStatusResponse: Codable {
    let status: Bool?
    let message: String?
    let data: PaymentStatusData?
    let errors: String?

    var errorMessage: String? {
        guard let errors = errors, !errors.isEmpty else { return message }
        let allErrors = errors
        return allErrors.isEmpty ? message : allErrors
    }
}

struct PaymentStatusData: Codable {
    let serviceRequestId: Int?
    let bookingStatus: String?
    let bookingPaymentStatus: String?
    let bookingPaymentMethod: String?
    let bookingTotalAmount: Double?
    let alreadyPaidAmount: Double?
    let totalPaidAmount: Double?
    let remainingAmount: Double?
    let isPaid: Bool?
    let isPartialPaid: Bool?
    let canPayMore: Bool?
    let minimumPartialAmount: Double?
    let latestPayment: LatestPaymentData?

    enum CodingKeys: String, CodingKey {
        case serviceRequestId = "service_request_id"
        case bookingStatus = "booking_status"
        case bookingPaymentStatus = "booking_payment_status"
        case bookingPaymentMethod = "booking_payment_method"
        case bookingTotalAmount = "booking_total_amount"
        case alreadyPaidAmount = "already_paid_amount"
        case totalPaidAmount = "total_paid_amount"
        case remainingAmount = "remaining_amount"
        case isPaid = "is_paid"
        case isPartialPaid = "is_partial_paid"
        case canPayMore = "can_pay_more"
        case minimumPartialAmount = "minimum_partial_amount"
        case latestPayment = "latest_payment"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        serviceRequestId = try? container.decode(Int.self, forKey: .serviceRequestId)
        bookingStatus = try? container.decode(String.self, forKey: .bookingStatus)
        bookingPaymentStatus = try? container.decode(String.self, forKey: .bookingPaymentStatus)
        bookingPaymentMethod = try? container.decode(String.self, forKey: .bookingPaymentMethod)

        bookingTotalAmount = container.decodeFlexibleDouble(forKey: .bookingTotalAmount)
        alreadyPaidAmount = container.decodeFlexibleDouble(forKey: .alreadyPaidAmount)
        totalPaidAmount = container.decodeFlexibleDouble(forKey: .totalPaidAmount)
        remainingAmount = container.decodeFlexibleDouble(forKey: .remainingAmount)
        minimumPartialAmount = container.decodeFlexibleDouble(forKey: .minimumPartialAmount)

        isPaid = try? container.decode(Bool.self, forKey: .isPaid)
        isPartialPaid = try? container.decode(Bool.self, forKey: .isPartialPaid)
        canPayMore = try? container.decode(Bool.self, forKey: .canPayMore)

        latestPayment = try? container.decode(LatestPaymentData.self, forKey: .latestPayment)
    }
}

struct LatestPaymentData: Codable {
    let paymentId: Int?
    let status: String?
    let paymentMethod: String?
    let gateway: String?
    let amount: Double?
    let currency: String?
    let failureCode: String?
    let failureMessage: String?
    let checkoutSessionId: String?
    let paymentIntentId: String?
    let stripeStatus: String?
    let attemptedAt: String?
    let paidAt: String?

    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case status
        case paymentMethod = "payment_method"
        case gateway
        case amount
        case currency
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
        case checkoutSessionId = "checkout_session_id"
        case paymentIntentId = "payment_intent_id"
        case stripeStatus = "stripe_status"
        case attemptedAt = "attempted_at"
        case paidAt = "paid_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        paymentId = try? container.decode(Int.self, forKey: .paymentId)
        status = try? container.decode(String.self, forKey: .status)
        paymentMethod = try? container.decode(String.self, forKey: .paymentMethod)
        gateway = try? container.decode(String.self, forKey: .gateway)
        amount = container.decodeFlexibleDouble(forKey: .amount)
        currency = try? container.decode(String.self, forKey: .currency)
        failureCode = try? container.decode(String.self, forKey: .failureCode)
        failureMessage = try? container.decode(String.self, forKey: .failureMessage)
        checkoutSessionId = try? container.decode(String.self, forKey: .checkoutSessionId)
        paymentIntentId = try? container.decode(String.self, forKey: .paymentIntentId)
        stripeStatus = try? container.decode(String.self, forKey: .stripeStatus)
        attemptedAt = try? container.decode(String.self, forKey: .attemptedAt)
        paidAt = try? container.decode(String.self, forKey: .paidAt)
    }
}
