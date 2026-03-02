//
//  BookingFareAmountVM.swift
//  Fixmycar UAE
//
//  Created by Ankit on 27/01/26.
//

import Foundation

class BookingFareAmountVM {
    
    var isScheduleBooking: Bool = false
    
    var successCalculatePrice: (() -> Void)?
    var failureCalculatePrice: ((String) -> Void)?
    
    var successAvailableDrivers: (() -> Void)?
    var failureAvailableDrivers: ((String) -> Void)?
    
    var priceData: PriceData?
    var availableDrivers: [DriverData] = []
    
    func getCalculatePrice(km: String) {
        let latitude = AppDelegate.appDelegate.currentLatitude
        let langitude = AppDelegate.appDelegate.currentLongitude
        let km = Double(km) ?? 0.0
        
        let params: [String: Any] = [
            "latitude": latitude,
            "longitude": langitude,
            "km": km
        ]
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.calculatePrice,
            parameters: params,
            responseType: PriceResponse.self) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureCalculatePrice?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureCalculatePrice?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureCalculatePrice?(response.message ?? "Failed")
                    return
                }
                
                self.priceData = response.data
                self.successCalculatePrice?()
            }
    }
    
    func getAvailableDrivers() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.availableDrivers,
            responseType: AvailableDriversResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureAvailableDrivers?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureAvailableDrivers?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureAvailableDrivers?(response.message ?? "Failed")
                    return
                }
                
                self.availableDrivers = response.data ?? []
                self.successAvailableDrivers?()
            }
    }
    
}
