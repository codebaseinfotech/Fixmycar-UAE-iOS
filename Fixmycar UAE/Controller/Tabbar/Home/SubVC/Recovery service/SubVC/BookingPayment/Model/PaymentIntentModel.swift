//
//  PaymentIntentModel.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/04/26.
//

import Foundation

// MARK: - PaymentIntent Response
struct PaymentIntentResponse: Codable {
    let status: Bool?
    let message: String?
    let data: PaymentIntentData?
}

// MARK: - PaymentIntent Data
struct PaymentIntentData: Codable {
    let clientSecret: String?
    let paymentIntentId: String?
    let customerId: String?
    let ephemeralKey: String?
    let amount: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
        case paymentIntentId = "payment_intent_id"
        case customerId = "customer_id"
        case ephemeralKey = "ephemeral_key"
        case amount
        case currency
    }
}
