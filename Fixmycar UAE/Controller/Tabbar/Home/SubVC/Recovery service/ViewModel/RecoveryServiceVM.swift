//
//  RecoveryServiceVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 25/02/26.
//

import Foundation

class RecoveryServiceVM {
    var successVehicleType: (() -> Void)?
    var failureVehicleType: ((String) -> Void)?
    
    var successVehicleIssue: (() -> Void)?
    var failureVehicleIssue: ((String) -> Void)?
    
    var successVehicleMake: (() -> Void)?
    var failureVehicleMake: ((String) -> Void)?
    
    var successVehicleModel: (() -> Void)?
    var failureVehicleModel: ((String) -> Void)?

    var successRecoveryTypes: (() -> Void)?
    var failureRecoveryTypes: ((String) -> Void)?

    var vehicleType: [VehicleType]?
    var vehicleIssue: [VehicleIssue]?
    var vehicleMake: [VehicleMake]?
    var vehicleModel: [VehicleModel]?
    var recoveryTypes: [RecoveryTypeOption]?
    
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
    
    func getVehicelMake() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.vehicelMake,
            responseType: VehicleMakeListResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureVehicleMake?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureVehicleMake?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureVehicleMake?(response.message ?? "Failed")
                    return
                }
                
                self.vehicleMake = response.data
                self.successVehicleMake?()
            }
    }
    
    func getVehicelModel(id: Int) {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.vehicleModel,
            pathComponent: "\(id)",
            responseType: ModelListResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureVehicleModel?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureVehicleModel?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureVehicleModel?(response.message ?? "Failed")
                    return
                }
                
                self.vehicleModel = response.data
                self.successVehicleModel?()
            }
    }

    // MARK: - Get Recovery Types (for Vehicle Type dropdown)
    func getRecoveryTypes() {
        let params: [String: Any] = ["audience": "customer"]

        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.recoveryTypes,
            parameters: params,
            responseType: RecoveryTypesResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                guard let self = self else { return }

                if let error = error {
                    self.failureRecoveryTypes?(error)
                    return
                }

                guard let response = response else {
                    self.failureRecoveryTypes?("Something went wrong")
                    return
                }

                if response.status == false {
                    self.failureRecoveryTypes?(response.message ?? "Failed")
                    return
                }

                self.recoveryTypes = response.data?.nameOptions
                self.successRecoveryTypes?()
            }
    }
}
