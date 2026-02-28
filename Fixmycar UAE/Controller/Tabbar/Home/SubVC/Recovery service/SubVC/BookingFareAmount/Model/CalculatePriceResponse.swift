//
//  CalculatePriceResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 13/02/26.
//

import Foundation

struct PriceResponse: Codable {
    let status: Bool?
    let message: String?
    let data: PriceData?
    let errors: String?
}

struct PriceData: Codable {
    let price: Double?
    let currency: String?
    let distanceKm: Double?
    
    enum CodingKeys: String, CodingKey {
        case price
        case currency
        case distanceKm = "distance_km"
    }
}
