//
//  Constants.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation

let google_place_key = "AIzaSyD4Fl5fv1u4g-96GrYYGCJmqCtTx6fs_CI"

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
}
