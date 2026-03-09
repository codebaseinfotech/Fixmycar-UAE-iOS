//
//  BookingConstants.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 13/02/26.
//

import Foundation

class CreateBooking {
    static let shared = CreateBooking()
    
    var service_type_id: Int = 1
    var promotion_id: Int = 0

    var pickup_address: String?
    var dropoff_address: String?
    
    var pickup_lat: Double?
    var pickup_lng: Double?
    
    var dropoff_lat: Double?
    var dropoff_lng: Double?
    
    var distance_km: String?
    
    var finalPrice: Double?
    
    var price: Double?
    var currency: String?
    
    var scheduled_at: String?
    var isScheduleBooking: Bool = false
    
    var booking_type: String?
    var vehicle_type: String?
    var issue: Int?
    var additional_notes: String?
    var discountPrice: String?
    var eta_minutes: String?
    var total_price: String?
    var platform_fee: String?
    var tax: String?
    var route_polyline: String?
}

// MARK: - rating Booking
class RatingBooking {
    static let shared = RatingBooking()

    var bookingId: Int?
}
