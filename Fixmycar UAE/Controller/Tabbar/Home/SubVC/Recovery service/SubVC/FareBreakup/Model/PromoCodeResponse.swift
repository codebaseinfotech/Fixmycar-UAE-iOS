//
//  PromoCodeResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

// MARK: - PromoCodeResponse
class PromoCodeResponse: Codable {
    var status: Bool?
    var message: String?
    var data: PromoCodeData?
    var errors: String?
}

// MARK: - PromoCodeData
class PromoCodeData: Codable {
    var id: Int?
    var code: String?
    var imageURL: String?
    var discountType: String?
    var discountValue: Int?
    var maxDiscountAmount: Int?
    var description: String?
    var isActive: Bool?
    var startDate: String?
    var endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case imageURL = "image_url"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case maxDiscountAmount = "max_discount_amount"
        case description
        case isActive = "is_active"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
