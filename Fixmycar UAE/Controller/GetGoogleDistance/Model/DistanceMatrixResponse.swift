//
//  DistanceMatrixResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 02/03/26.
//

import Foundation

// MARK: - Root
struct DistanceMatrixResponse: Codable {
    let destinationAddresses: [String]?
    let originAddresses: [String]?
    let rows: [DistanceMatrixRow]?
    let status: String?
    let errorMessage: String?   // ✅ ADD THIS
    
    enum CodingKeys: String, CodingKey {
        case destinationAddresses = "destination_addresses"
        case originAddresses = "origin_addresses"
        case rows
        case status
        case errorMessage = "error_message"
    }
}
// MARK: - Row
struct DistanceMatrixRow: Codable {
    let elements: [DistanceMatrixElement]?
}

// MARK: - Element
struct DistanceMatrixElement: Codable {
    let distance: DistanceValue?
    let duration: DistanceValue?
    let durationInTraffic: DistanceValue?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case durationInTraffic = "duration_in_traffic"
        case status
    }
}

// MARK: - Distance/Duration
struct DistanceValue: Codable {
    let text: String?
    let value: Int?
}
