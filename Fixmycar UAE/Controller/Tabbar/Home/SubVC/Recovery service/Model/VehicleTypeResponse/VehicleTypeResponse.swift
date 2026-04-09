//
//  VehicleTypeResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 25/02/26.
//

import Foundation

// MARK: - VehicleTypeResponse
class VehicleTypeResponse: Codable {
    var status: Bool?
    var message: String?
    var data: [VehicleType]?
    var errors: String?
}

// MARK: - VehicleType
class VehicleType: Codable {
    var id: String?
    var key: String?
    var name: String?
    var image: String?
}

// MARK: - RecoveryTypesResponse
struct RecoveryTypesResponse: Codable {
    var status: Bool?
    var message: String?
    var data: RecoveryTypesData?
    var errors: String?
}

// MARK: - RecoveryTypesData
struct RecoveryTypesData: Codable {
    var nameOptions: [RecoveryTypeOption]?

    enum CodingKeys: String, CodingKey {
        case nameOptions = "name_options"
    }
}

// MARK: - RecoveryTypeOption
struct RecoveryTypeOption: Codable {
    var id: String?
    var name: String?
}
