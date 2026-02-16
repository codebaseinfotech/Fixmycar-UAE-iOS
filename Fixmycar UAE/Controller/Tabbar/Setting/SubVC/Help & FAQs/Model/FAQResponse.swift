//
//  FAQResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

// MARK: - FAQResponse
struct FAQResponse: Codable {
    let status: Bool
    let message: String?
    let data: FAQData?
    let errors: String?
}

// MARK: - FAQData
struct FAQData: Codable {
    let category: String?
    let faqs: [FAQ]?
}

// MARK: - FAQ
struct FAQ: Codable {
    let id: Int?
    let question: String?
    let answer: String?
    let category: String?
}
