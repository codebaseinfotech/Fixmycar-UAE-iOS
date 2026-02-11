//
//  BookingDetailsVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

class BookingDetailsVM {
    var successBookingDetails: (() -> Void)?
    var failureBookingDetails: ((String) -> Void)?
    
    var bookingDetails: BookingDetails?
    
    var bookingid: Int?
    func getBookingDetails() {
        
        let pathComponents = "/" + "\(bookingid ?? 0)"
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.bookingList,
            pathComponent: pathComponents,
            responseType: BookingDetailsResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureBookingDetails?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureBookingDetails?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureBookingDetails?(response.message ?? "Failed")
                    return
                }
                
                self.bookingDetails = response.data
                self.successBookingDetails?()
            }
    }
}
