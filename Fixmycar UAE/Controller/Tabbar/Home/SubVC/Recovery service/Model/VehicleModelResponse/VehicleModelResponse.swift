//
//  VehicleModelResponse.swift
//  FixMyCar UAE
//
//  Created by Kenil on 24/03/26.
//

import Foundation

// MARK: - Main Response
struct ModelListResponse: Codable {
    let status: Bool?
    let message: String?
    let make: VehicleMake?
    let data: [VehicleModel]?
}

// MARK: - Vehicle Model
struct VehicleModel: Codable {
    let id: Int?
    let makeId: Int?
    let name: String?
    let image: String?
    let imageURL: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image, status
        case makeId = "make_id"
        case imageURL = "image_url"
    }
}
