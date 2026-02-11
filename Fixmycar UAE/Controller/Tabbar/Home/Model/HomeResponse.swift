//
//  HomeResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

// MARK: - HomeResponse
struct HomeResponse: Codable {
    let status: Bool?
    let message: String?
    let data: HomeData?
    let errors: String?
}

// MARK: - HomeData
struct HomeData: Codable {
    let user: HomeUser?
    let banners: [HomeBanner]?
    let services: [HomeService]?
    let recentRequests: [RecentRequest]?
    
    enum CodingKeys: String, CodingKey {
        case user
        case banners
        case services
        case recentRequests = "recent_requests"
    }
}

// MARK: - HomeUser
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

// MARK: - HomeBanner
struct HomeBanner: Codable {
    // Add properties later if API sends banner data
}

// MARK: - HomeBanner
struct HomeService: Codable {
    let id: Int?
    let name: String?
    let icon: String?
    let slug: String?
}

// MARK: - RecentRequest
struct RecentRequest: Codable {
    let serviceName: String?
    let status: String?
    let dateTime: String?
    let pickupAddress: String?
    let dropAddress: String?
    let amount: Int?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case status
        case dateTime = "date_time"
        case pickupAddress = "pickup_address"
        case dropAddress = "drop_address"
        case amount
        case currency
    }
}
