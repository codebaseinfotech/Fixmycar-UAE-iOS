//
//  HomeVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 11/02/26.
//

import Foundation


class HomeVM {
    var successHomeData: (()->Void)?
    var failureHomeData: ((String)->Void)?
    
    var homeData: HomeData?
    var recentServiceList: [HomeBooking] = []
    
    var homeBanner: [HomeBanner] = []
    var homeServices: [HomeService] = []
    
    func getHomeData() {
        
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.homePage,
            responseType: HomeResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                
                guard let self = self else { return }
                
                // 🔴 If error
                if let errorMessage = error {
                    debugPrint("❌ APIClient Error:", error ?? "")
                    debugPrint("❌ Status Code:", statusCode ?? 0)
                    self.failureHomeData?(error ?? "")
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
                
                if statusCode == 401 {
                    FCUtilites.saveIsGetCurrentUser(false)
                    FCUtilites.saveCurrentUser(nil)
                    AppDelegate.appDelegate.setUpLogin()
                } else {
                    self.homeData = response.data
                    self.recentServiceList = response.data?.recentRequests ?? []
                    self.homeBanner = response.data?.banners ?? []
                    self.homeServices = response.data?.services ?? []
                    self.successHomeData?()
                }
                
               
            }
    }

}
