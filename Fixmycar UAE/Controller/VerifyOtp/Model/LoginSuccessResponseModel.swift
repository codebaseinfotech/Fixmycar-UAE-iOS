//
//  LoginSuccessResponseModel.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
//

import Foundation

// MARK: - Root Response
struct LoginSuccessResponseModel: Codable {
    let status: Bool?
    let message: String?
    let data: LoginSuccessData?
    let errors: [String]?
}

// MARK: - Data
struct LoginSuccessData: Codable {
    let isRegistered: Bool?
    let user: User?
    let accessToken: String?
    let roleName: String?

    enum CodingKeys: String, CodingKey {
        case isRegistered = "is_registered"
        case user
        case accessToken = "access_token"
        case roleName = "role_name"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let countryCode: String?
    let avatar: String?
    let status: String?
    let language: String?
    let referralCode: String?
    let referredBy: String?
    let customerDetails: CustomerDetails?
    let joinedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, avatar, status, language
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case referralCode = "referral_code"
        case referredBy = "referred_by"
        case customerDetails = "customer_details"
        case joinedAt = "joined_at"
    }
}

// MARK: - Customer Details
struct CustomerDetails: Codable {
    let id: Int?
    let name: String?
    let status: String?
}
