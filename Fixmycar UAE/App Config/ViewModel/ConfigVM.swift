//
//  ConfigVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 25/02/26.
//

import Foundation

final class ConfigVM: ObservableObject {

    var successGeneralSetting: (() -> Void)?
    var failuerGeneralSetting: ((String) -> Void)?

    var configResponse: AppConfigData?

    func getGeneralSettings() {
        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.get_config,
            needUserToken: false,
            responseType: AppConfigResponse.self,
            parameterEncoding: .url
        ) { [weak self] response, errorMessage, statusCode in

            guard let self = self else { return }

            if let errorMessage = errorMessage {
                self.failuerGeneralSetting?(errorMessage)
                return
            }

            guard let response = response else {
                self.failuerGeneralSetting?("Empty response")
                return
            }

            guard response.status == true else {
                self.failuerGeneralSetting?(response.message ?? "Something went wrong")
                return
            }

            guard let settings = response.data?.generalSettings else {
                self.failuerGeneralSetting?("General settings not found")
                return
            }

            self.configResponse = response.data
            self.successGeneralSetting?()
        }
    }
}
