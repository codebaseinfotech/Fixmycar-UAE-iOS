//
//  AppDelegateVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/03/26.
//

import Foundation

class AppDelegateVM {
    var dicCheckAppData: AppUpdateData?

    var onSuccess: (() -> Void)?
    var onFailure: ((String) -> Void)?

    func checkAppStatusApi() {

        let param: [String: Any] = [
            "version": AppUtilites.sharedInstance.version,
            "device_type": 1,
            "app_type": "customer"
        ]

        APIClient.sharedInstance.request(
            method: .post,
            url: .checkAppStatus,
            parameters: param,
            needUserToken: false,
            responseType: AppUpdateResponse.self,
            parameterEncoding: .json
        ) { [weak self] response, message, statusCode in

            guard let self = self else { return }

            if let response = response, response.status ?? false, let data = response.data {
                self.dicCheckAppData = data
                self.onSuccess?()
            } else {
                self.onFailure?(message ?? "Something went wrong")
                debugPrint("Error App Status", message ?? "")
            }
        }
    }
}
