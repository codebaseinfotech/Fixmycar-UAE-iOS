//
//  BookingFareAmountVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 27/01/26.
//

import Foundation

class BookingFareAmountVM {
    
    var isScheduleBooking: Bool = false
    
    var successCalculatePrice: (() -> Void)?
    var failureCalculatePrice: ((String) -> Void)?
    
    var successAvailableDrivers: (() -> Void)?
    var failureAvailableDrivers: ((String) -> Void)?

    var successDriversAvailabilityStatus: (() -> Void)?
    var failureDriversAvailabilityStatus: ((String) -> Void)?

    var priceData: PriceData?
    var availableDrivers: [DriverData] = []
    var isDriversAvailable: Bool = true
    var driversAvailabilityMessage: String = ""
    
    func getCalculatePrice(km: String, minutes: Int) {
        let latitude = AppDelegate.appDelegate.currentLatitude
        let langitude = AppDelegate.appDelegate.currentLongitude
        let km = Double(km) ?? 0.0
        let minutes = minutes
        
        let params: [String: Any] = [
            "latitude": latitude,
            "longitude": langitude,
            "km": km,
            "minutes": minutes
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

    // MARK: - Check Drivers Availability Status
    func checkDriversAvailabilityStatus() {
        let params: [String: Any] = [
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0
        ]

        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.driversAvailabilityStatus,
            parameters: params,
            responseType: DriversAvailabilityResponse.self) { [weak self] response, error, statusCode in

                guard let self = self else { return }

                if let error = error {
                    self.failureDriversAvailabilityStatus?(error)
                    return
                }

                guard let response = response else {
                    self.failureDriversAvailabilityStatus?("Something went wrong")
                    return
                }

                if response.status == false {
                    self.failureDriversAvailabilityStatus?(response.message ?? "Failed")
                    return
                }

                self.isDriversAvailable = response.data?.isDriversStatus ?? false
                self.driversAvailabilityMessage = response.message ?? ""
                self.successDriversAvailabilityStatus?()
            }
    }
}

// MARK: - Drivers Availability Response
struct DriversAvailabilityResponse: Codable {
    var status: Bool?
    var message: String?
    var data: DriversAvailabilityData?
    var errors: String?
}

struct DriversAvailabilityData: Codable {
    var isDriversStatus: Bool?
    var matchedWindowMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case isDriversStatus = "is_drives_status"
        case matchedWindowMinutes = "matched_window_minutes"
    }
}
