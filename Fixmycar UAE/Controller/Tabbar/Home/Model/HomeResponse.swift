//
//  HomeResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

// MARK: - Main Response
struct HomeResponse: Codable {
    let status: Bool?
    let message: String?
    let data: HomeData?
    let errors: String?
}

// MARK: - Home Data
struct HomeData: Codable {
    let user: HomeUser?
    let banners: [HomeBanner]?
    let services: [HomeService]?
    let activeBooking: [HomeBooking]?
    let recentRequests: [HomeBooking]?
    
    enum CodingKeys: String, CodingKey {
        case user
        case banners
        case services
        case activeBooking = "active_booking"
        case recentRequests = "recent_requests"
    }
}

// MARK: - User
struct HomeUser: Codable {
    let id: Int?
    let name: String?
    let selectedLocation: String?
    let unreadNotifications: Int?
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case selectedLocation = "selected_location"
        case unreadNotifications = "unread_notifications"
        case avatar
    }
}

// MARK: - Banner
struct HomeBanner: Codable {
    let id: Int?
    let title: String?
    let imageURL: String?
    let buttonText: String?
    let promoCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
        case buttonText = "button_text"
        case promoCode = "promo_code"
    }
}

// MARK: - Service
struct HomeService: Codable {
    let id: Int?
    let name: String?
    let icon: String?
    let slug: String?
}

// MARK: - Booking (Used for both Active & Recent)
struct HomeBooking: Codable {
    let id: Int?
    let serviceName: String?
    let status: String?
    let jobDate: String?
    let pickupAddress: String?
    let dropAddress: String?
    let amount: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case serviceName = "service_name"
        case status
        case jobDate = "job_date"
        case pickupAddress = "pickup_address"
        case dropAddress = "drop_address"
        case amount
        case currency
    }
}
