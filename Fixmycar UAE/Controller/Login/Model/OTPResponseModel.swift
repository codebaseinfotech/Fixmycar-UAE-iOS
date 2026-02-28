//
//  OTPResponseModel.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 28/01/26.
//

import Foundation

// MARK: - OTP Response Model
struct OTPResponseModel: Codable {
    let status: Bool?
    let message: String?
    let data: OTPData?
    let errors: String?
}

// MARK: - OTP Data
struct OTPData: Codable {
    let phone: String?
    let otpDebug: Int?

    enum CodingKeys: String, CodingKey {
        case phone
        case otpDebug = "otp_debug"
    }
}
