//
//  VehicleTypeResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
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
