//
//  LogoutResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
//

import Foundation

struct LogoutResponse: Codable {
    let status: Bool
    let message: String
    let data: EmptyData?
}

struct EmptyData: Codable {}
