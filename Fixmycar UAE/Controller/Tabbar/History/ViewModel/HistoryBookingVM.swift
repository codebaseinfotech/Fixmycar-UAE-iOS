//
//  HistoryBookingVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 11/02/26.
//

import Foundation

class HistoryBookingVM {
    var successHistoryData: (()->Void)?
    var failureHistoryData: ((String)->Void)?

    var historyBookingList: [BookingItem] = []

    // Pagination properties
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoading: Bool = false

    var hasMorePages: Bool {
        return currentPage < totalPages
    }

    func getHistoryBookingData(isLoadMore: Bool = false) {
        guard !isLoading else { return }

        if isLoadMore {
            guard hasMorePages else { return }
            currentPage += 1
        } else {
            currentPage = 1
            historyBookingList = []
        }

        isLoading = true

        let params: [String: Any] = ["page": currentPage]

        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.bookingList,
            parameters: params,
            responseType: BookingHistoryResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in

                guard let self = self else { return }

                self.isLoading = false

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

                let newItems = response.data?.data ?? []
                self.historyBookingList.append(contentsOf: newItems)

                // Update pagination info
                self.totalPages = response.data?.meta?.lastPage ?? 1

                self.successHistoryData?()
            }
    }

}
