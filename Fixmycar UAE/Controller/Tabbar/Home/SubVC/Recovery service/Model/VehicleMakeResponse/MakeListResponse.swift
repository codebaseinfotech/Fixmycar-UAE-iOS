//
//  MakeListResponse.swift
//  FixMyCar UAE
//
//  Created by Kenil on 24/03/26.
//

import Foundation

// MARK: - Main Response
struct VehicleMakeListResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [VehicleMake]?
}

// MARK: - Make Model
struct VehicleMake: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let imageURL: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case imageURL = "image_url"
        case status
    }
}
