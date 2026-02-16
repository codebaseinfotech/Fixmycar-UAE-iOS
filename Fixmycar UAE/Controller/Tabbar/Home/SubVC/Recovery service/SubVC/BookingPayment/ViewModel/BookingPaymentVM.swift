//
//  BookingPaymentVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import Foundation

class BookingPaymentVM {
    var successCreateBooking: (() -> Void)?
    var failureCreateBooking: ((String) -> Void)?
    
    func createBooking() {
        APIClient.sharedInstance.showIndicaor()
        
        let params: [String: Any] = [
            "service_type_id": CreateBooking.shared.service_type_id,
            "pickup_address": CreateBooking.shared.pickup_address ?? "",
            "dropoff_address": CreateBooking.shared.dropoff_address ?? "",
            "distance_km": CreateBooking.shared.distance_km ?? 0.0,
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0,
            "dropoff_lat": CreateBooking.shared.dropoff_lat ?? 0.0,
            "dropoff_lng": CreateBooking.shared.dropoff_lng ?? 0.0,
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.bookingList,
            parameters: params,
            responseType: BookingResponseModel.self) { [weak self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureCreateBooking?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureCreateBooking?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureCreateBooking?(response.message ?? "Failed")
                    return
                }
                
                self.successCreateBooking?()
            }
        
    }
}
