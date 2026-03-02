//
//  GoogleDistanceVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 02/03/26.
//

import Foundation
import Alamofire

class GoogleDistanceVM {
    
    var successGoogleDistance: (()->Void)?
    var failureGoogleDistance: ((String)->Void)?
    
    var distanceWithName: String = ""
    var distance: String = ""
    
    var duration: String = ""
    var durationWithName: String = ""
    
    func getDistance(originLat: Double,
                     originLng: Double,
                     destLat: Double,
                     destLng: Double) {

        let key = google_place_key
        let departure_time = "now"
        let mode = "driving"
        let origins = "\(originLat),\(originLng)"
        let destinations = "\(destLat),\(destLng)"
        
        let pathCompponents = "?" + "key=\(key)" + "&origins=\(origins)" + "&destinations=\(destinations)" + "&mode=\(mode)" + "&departure_time=\(departure_time)"
        
        APIClient.sharedInstance.requestGoogleDistance(
            pathComponent: pathCompponents,
            responseType: DistanceMatrixResponse.self) { response, error, statusCode in
                // If error
                if let error = error {
                    self.failureGoogleDistance?(error)
                    return
                }
                
                // If response is nil
                guard let response = response else {
                    self.failureGoogleDistance?("Something went wrong")
                    return
                }
                
                // If API status false
                if (response.status != nil) == false {
                    self.failureGoogleDistance?("Failed")
                    return
                }
                
                self.distanceWithName = response.rows?.first?.elements?.first?.distance?.text ?? ""
                self.distance = response.rows?.first?.elements?.first?.distance?.text?.replacingOccurrences(of: " km", with: "") ?? ""
                
                self.durationWithName = response.rows?.first?.elements?.first?.durationInTraffic?.text ?? ""
                self.duration = response.rows?.first?.elements?.first?.durationInTraffic?.text?.replacingOccurrences(of: " mins", with: "") ?? ""

                self.successGoogleDistance?()
            }
    }
    
}
