//
//  TrackLiveVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 19/02/26.
//

import Foundation

class TrackLiveVM {
    var successTrackLive: (() -> Void)?
    var failureTrackLive: ((String) -> Void)?

    var successCheckoutUrl: ((String) -> Void)?
    var failureCheckoutUrl: ((String) -> Void)?

    var successPaymentStatus: (() -> Void)?
    var failurePaymentStatus: ((String) -> Void)?

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

    // MARK: - Get Stripe Checkout URL for Remaining Payment
    func getStripeCheckoutUrl() {
        guard let bookingId = bookingId else {
            failureCheckoutUrl?("Booking ID not found")
            return
        }

        APIClient.sharedInstance.showIndicaor()

        let params: [String: Any] = [
            "service_request_id": bookingId
        ]

        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.stripeCheckoutUrl,
            parameters: params,
            responseType: StripeCheckoutResponse.self) { [weak self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                guard let self = self else { return }

                if let error = error {
                    self.failureCheckoutUrl?(error)
                    return
                }

                guard let response = response else {
                    self.failureCheckoutUrl?("Something went wrong")
                    return
                }

                if response.status == false {
                    self.failureCheckoutUrl?(response.message ?? "Failed to get checkout URL")
                    return
                }

                guard let checkoutUrl = response.data?.checkoutUrl, !checkoutUrl.isEmpty else {
                    self.failureCheckoutUrl?("Checkout URL not available")
                    return
                }

                self.successCheckoutUrl?(checkoutUrl)
            }
    }

    // MARK: - Check Payment Status
    func checkPaymentStatus() {
        guard let bookingId = bookingId else {
            failurePaymentStatus?("Booking ID not found")
            return
        }

        APIClient.sharedInstance.showIndicaor()

        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.paymentStatus,
            parameters: [:],
            pathComponent: "\(bookingId)/status",
            responseType: PaymentStatusResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                guard let self = self else { return }

                if let error = error {
                    self.failurePaymentStatus?(error)
                    return
                }

                guard let response = response else {
                    self.failurePaymentStatus?("Something went wrong")
                    return
                }

                if response.status == false {
                    self.failurePaymentStatus?(response.message ?? "Payment verification failed")
                    return
                }

                // Check payment status
                let paymentStatus = response.data?.bookingPaymentStatus?.lowercased() ?? ""
                let isPaid = response.data?.isPaid ?? false

                if isPaid || paymentStatus == "paid" || paymentStatus == "completed" || paymentStatus == "success" || paymentStatus == "succeeded" {
                    self.successPaymentStatus?()
                } else if paymentStatus == "pending" {
                    self.failurePaymentStatus?("Payment is still pending. Please complete the payment.")
                } else if paymentStatus == "failed" {
                    self.failurePaymentStatus?("Payment failed. Please try again.")
                } else {
                    self.failurePaymentStatus?("Payment not completed")
                }
            }
    }
}
