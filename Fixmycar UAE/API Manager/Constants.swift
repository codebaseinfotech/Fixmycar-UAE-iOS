//
//  Constants.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation

let BASE_URL = "https://admin-dev.torettorecovery.ae/api/"

let google_place_key = "AIzaSyD4Fl5fv1u4g-96GrYYGCJmqCtTx6fs_CI"


enum APIEndPoint: String {
    
    case loginUser = "v1/customer/login"
    case verifyOtp = "v1/customer/verify-otp"
    case register = "v1/customer/register"
}
