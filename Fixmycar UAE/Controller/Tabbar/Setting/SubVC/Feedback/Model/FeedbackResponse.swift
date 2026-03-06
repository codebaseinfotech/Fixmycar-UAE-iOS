//
//  FeedbackResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
//

import Foundation

struct FeedbackResponse: Codable {
    let status: Bool
    let message: String
    let data: EmptyData?
    let errors: String?
}
