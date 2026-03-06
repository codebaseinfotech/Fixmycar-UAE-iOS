//
//  CancelBookingVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 03/03/26.
//

import Foundation

class CancelBookingVM {
    
    var successCancelBooking: ((String) -> Void)?
    var failureCancelBooking: ((String) -> Void)?
    
    var cancelResponse: CancelBookingResponse?
    
    func bookingCancel(bookingId: Int, reasonId: Int, notes: String) {
        
        let params: [String: Any] = [
            "reason_id": reasonId,
            "notes": notes
        ]
        
        let pathComponets = "/\(bookingId)" + "/cancel"
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.cancelBooking,
            parameters: params,
            pathComponent: pathComponets,
            responseType: CancelBookingResponse.self,
            parameterEncoding: .json) { [weak self] response, error, statusCode in
                
                APIClient.sharedInstance.hideIndicator()
                
                guard let self = self else { return }
                
                if let error = error {
                    self.failureCancelBooking?(error)
                    return
                }
                
                guard let response = response else {
                    self.failureCancelBooking?("Something went wrong")
                    return
                }
                
                if response.status == true {
                    self.successCancelBooking?(response.message ?? "")
                } else {
                    self.failureCancelBooking?(response.message ?? "")
                }
            }
    }
    
}
