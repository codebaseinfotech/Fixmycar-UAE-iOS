//
//  FAQResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
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
    let title: String?
    let faqs: [FAQ]?
    let type: String?
}

// MARK: - FAQ
struct FAQ: Codable {
    let question: String?
    let answer: String?
}
