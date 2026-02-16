//
//  LegalInfoResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

// MARK: - LegalInfoResponse
struct LegalInfoResponse: Codable {
    let status: Bool
    let message: String
    let data: LegalInfoData?
    let errors: String?
}

// MARK: - LegalInfoData
struct LegalInfoData: Codable {
    let title: String
    let content: String
    let type: String
}
