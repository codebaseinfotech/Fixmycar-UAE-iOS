//
//  HistoryBookingVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

class HistoryBookingVM {
    var successHistoryData: (()->Void)?
    var failureHistoryData: ((String)->Void)?

    var historyBookingList: [BookingItem] = []
    
    func getHistoryBookingData() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.bookingList,
            responseType: BookingHistoryResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureHistoryData?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureHistoryData?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureHistoryData?(response.message ?? "Failed")
                    return
                }
                
                self.historyBookingList = response.data?.data ?? []
                self.successHistoryData?()
            }
    }
    
}
