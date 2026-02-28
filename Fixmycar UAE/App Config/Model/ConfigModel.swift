//
//  ConfigModel.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

struct AppConfigResponse: Codable {
    let status: Bool
    let message: String?
    let data: AppConfigData?
    let errors: String?
}

struct AppConfigData: Codable {
    let jobManageActions: [KeyValueItem]
    let jobProgressStatuses: [KeyValueItem]
    let payoutTypes: [KeyValueItem]
    let appContentTypes: [String]
    let generalSettings: GeneralSettings
    
    enum CodingKeys: String, CodingKey {
        case jobManageActions = "job_manage_actions"
        case jobProgressStatuses = "job_progress_statuses"
        case payoutTypes = "payout_types"
        case appContentTypes = "app_content_types"
        case generalSettings = "general_settings"
    }
}

struct KeyValueItem: Codable {
    let key: String
    let value: String
}

struct GeneralSettings: Codable {
    let showRegisterFee: Bool?
    let registerFeeAmount: Double?
    let showPlatformFee: Bool?
    let platformFeeAmount: Double?
    let showTax: Bool
    let taxAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case showRegisterFee = "show_register_fee"
        case registerFeeAmount = "register_fee_amount"
        case showPlatformFee = "show_platform_fee"
        case platformFeeAmount = "platform_fee_amount"
        case showTax = "show_tax"
        case taxAmount = "tax_amount"
    }
}
