//
//  AvailableDriversResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 13/02/26.
//

import Foundation

struct AvailableDriversResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [DriverData]?
    let errors: String?
}

struct DriverData: Codable {
    let id: Int?
    let fullName: String?
    let phone: String?
    let vehicleType: String?
    let licenseNumber: String?
    let isOnline: Bool?
    let location: DriverLocation?
    let distanceKm: Double?
    let estimatedTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case phone
        case vehicleType = "vehicle_type"
        case licenseNumber = "license_number"
        case isOnline = "is_online"
        case location
        case distanceKm = "distance_km"
        case estimatedTime = "estimated_time"
    }
}

struct DriverLocation: Codable {
    let latitude: Double?
    let longitude: Double?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case updatedAt = "updated_at"
    }
}
