//
//  Constants.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation

let google_place_key = "AIzaSyD4Fl5fv1u4g-96GrYYGCJmqCtTx6fs_CI"
var ONE_SINGNAL_ID = "7c0b8947-9a28-4b72-ad45-87403b4676f2"

enum AppEnviroment {
    case live
    case dev
}

let current: AppEnviroment = .dev

// ************************* LIVE ***********************
let BASE_URL = current == .live ? "https://admin.torettorecovery.ae/api/" : "https://admin-dev.torettorecovery.ae/api/"

enum APIEndPoint: String {
    
    case loginUser = "v1/customer/login"
    case verifyOtp = "v1/customer/verify-otp"
    case register = "v1/customer/register"
    case updateProfile = "v1/customer/profile"
    case homePage = "v1/customer/home"
    case bookingList = "v1/customer/bookings"
    case calculatePrice = "v1/customer/price/calculate"
    case availableDrivers = "v1/customer/available-drivers"
    case terms = "v1/common/legal/terms"
    case privacy = "v1/common/legal/privacy"
    case about = "v1/common/legal/about"
    case faqs = "v1/common/faqs"
    case support = "v1/driver/support"
    case feedback = "v1/common/feedback"
    case logoutUser = "v1/logout"
    case deleteAccount = "v1/delete-account"
    case vehicle_type = "v1/common/vehicle-types"
    case vehicle_issue = "v1/common/vehicle-issues"
    case promo_code_verify = "v1/customer/promocodes/verify"
    case get_config = "v1/common/config"
    case chat_list = "v1/chat/inbox"
}

 
