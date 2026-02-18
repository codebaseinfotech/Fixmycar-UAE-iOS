//
//  HomeVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation


class HomeVM {
    var successHomeData: (()->Void)?
    var failureHomeData: ((String)->Void)?
    
    var homeData: HomeData?
    var recentServiceList: [HomeBooking] = []
    
    func getHomeData() {
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.homePage,
            responseType: HomeResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureHomeData?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureHomeData?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureHomeData?(response.message ?? "Failed")
                    return
                }
                
                self.homeData = response.data
                self.recentServiceList = response.data?.recentRequests ?? []
                self.successHomeData?()
            }
    }

}
