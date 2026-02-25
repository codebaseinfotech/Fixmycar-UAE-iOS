//
//  VehicleIssueResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

// MARK: - VehicleIssueResponse
class VehicleIssueResponse: Codable {
    var status: Bool?
    var message: String?
    var data: [VehicleIssue]?
    var errors: String?
}

// MARK: - VehicleIssue
class VehicleIssue: Codable {
    var id: Int?
    var code: String?
    var name: String?
    var image: String?
}
