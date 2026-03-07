//
//  CheckAppStatusModel.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/03/26.
//

import Foundation

// MARK: - AppUpdateResponse
struct AppUpdateResponse: Codable {
    let status: Bool?
    let message: String?
    let data: AppUpdateData?
    let errors: String?
}

struct AppUpdateData: Codable {
    let isMaintenance: Bool?
    let updateAvailable: Bool?
    let forceUpdate: Bool?
    let currentVersion: String?
    let latestVersion: String?
    let minimumSupportedVersion: String?
    let appLink: String?
    let features: [String]?
    let buttons: UpdateButtons?

    enum CodingKeys: String, CodingKey {
        case isMaintenance = "is_maintenance"
        case updateAvailable = "update_available"
        case forceUpdate = "force_update"
        case currentVersion = "current_version"
        case latestVersion = "latest_version"
        case minimumSupportedVersion = "minimum_supported_version"
        case appLink = "app_link"
        case features
        case buttons
    }
}

struct UpdateButtons: Codable {
    let okText: String?
    let cancelText: String?

    enum CodingKeys: String, CodingKey {
        case okText = "ok_text"
        case cancelText = "cancel_text"
    }
}
