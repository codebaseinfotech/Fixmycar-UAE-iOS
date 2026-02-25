//
//  RecoveryServiceVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

class RecoveryServiceVM {
    var successVehicleType: (() -> Void)?
    var failureVehicleType: ((String) -> Void)?
    
    var successVehicleIssue: (() -> Void)?
    var failureVehicleIssue: ((String) -> Void)?
    
    var vehicleType: [VehicleType]?
    var vehicleIssue: [VehicleIssue]?
    
    func getVehicleType() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.vehicle_type,
            responseType: VehicleTypeResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureVehicleType?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureVehicleType?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureVehicleType?(response.message ?? "Failed")
                    return
                }
                
                self.vehicleType = response.data
                self.successVehicleType?()
            }
    }
    
    func getVehicleIssue() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.vehicle_issue,
            responseType: VehicleIssueResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureVehicleType?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureVehicleType?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureVehicleType?(response.message ?? "Failed")
                    return
                }
                
                self.vehicleIssue = response.data
                self.successVehicleIssue?()
            }
    }
}
