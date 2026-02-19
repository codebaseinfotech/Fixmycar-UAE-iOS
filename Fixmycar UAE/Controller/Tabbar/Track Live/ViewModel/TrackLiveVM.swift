//
//  TrackLiveVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 19/02/26.
//

import Foundation

class TrackLiveVM {
    var successTrackLive: (() -> Void)?
    var failureTrackLive: ((String) -> Void)?
    
    var trackBookingDetails: BookingTrackingData?
    var bookingId: Int?
        
    func getTrackLiveDetails() {
        let pathComponets = "/\(bookingId ?? 0)" + "/track"
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.bookingList,
            pathComponent: pathComponets,
            responseType: BookingTrackingResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                APIClient.sharedInstance.hideIndicator()
                
                guard let self = self else { return }
                
                if let error = error {
                    self.failureTrackLive?(error)
                    return
                }
                
                guard let response = response else {
                    self.failureTrackLive?("Something went wrong")
                    return
                }
                
                if response.status == true {
                    trackBookingDetails = response.data
                    self.successTrackLive?()
                } else {
                    self.failureTrackLive?(response.message ?? "")
                }
            }
    }
}
