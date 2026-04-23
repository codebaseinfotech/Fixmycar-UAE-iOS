//
//  BookingPaymentVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
//

import Foundation
import UIKit

class BookingPaymentVM {
    var successCheckoutUrl: ((String) -> Void)?
    var failureCheckoutUrl: ((String) -> Void)?

    var successPaymentStatus: (() -> Void)?
    var failurePaymentStatus: ((String) -> Void)?

    private var currentPrepaymentId: Int?
    private var currentPaymentAmount: Double?

    // MARK: - Trip Prepayments API
    func getTripPrepaymentUrl(amount: Double) {
        currentPaymentAmount = amount
        APIClient.sharedInstance.showIndicaor()

        // Build recovery_types_id array
        var recoveryTypesIds: [Int] = []
        if let recoveryTypeId = CreateBooking.shared.recovery_types_id {
            recoveryTypesIds.append(recoveryTypeId)
        }

        // Build vehical_image files for multipart upload
        var files: [MultipartFile] = []
        if let images = CreateBooking.shared.vehical_image {
            for (index, image) in images.enumerated() {
                if let data = image.jpegData(compressionQuality: 0.7) {
                    files.append(MultipartFile(
                        key: "vehical_image[\(index)]",
                        fileName: "image_\(index).jpg",
                        data: data,
                        mimeType: "image/jpeg"
                    ))
                }
            }
        }

        var params: [String: Any] = [
            "service_type_id": CreateBooking.shared.service_type_id,
            "pickup_address": CreateBooking.shared.pickup_address ?? "",
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0,
            "dropoff_address": CreateBooking.shared.dropoff_address ?? "",
            "dropoff_lat": CreateBooking.shared.dropoff_lat ?? 0.0,
            "dropoff_lng": CreateBooking.shared.dropoff_lng ?? 0.0,
            "distance_km": Double(CreateBooking.shared.distance_km ?? "0") ?? 0.0,
            "eta_minutes": Int(CreateBooking.shared.eta_minutes ?? "0") ?? 0,
            "booking_type": CreateBooking.shared.booking_type ?? "immediate",
            "payment_method": "payment_link",
            "prepayment_amount": amount,
            "issue": CreateBooking.shared.issue ?? 0,
            "additional_notes": CreateBooking.shared.additional_notes ?? ""
        ]

        // Add recovery_types_id as flattened array params for multipart
        for (index, typeId) in recoveryTypesIds.enumerated() {
            params["recovery_types_id[\(index)]"] = typeId
        }

        if CreateBooking.shared.isScheduleBooking {
            let date = CreateBooking.shared.scheduled_at?.toDisplayDate(apiFormat: "dd MMM yyyy hh:mm a", displayFormat: "yyyy-MM-dd HH:mm:ss")
            params["scheduled_at"] = date
        }

        debugPrint("Trip Prepayment Params: ", params)
        debugPrint("Trip Prepayment Files Count: ", files.count)

        APIClient.sharedInstance.uploadMultipart(
            urlString: .tripPrepayments,
            parameters: params,
            files: files) { [weak self] result in
                APIClient.sharedInstance.hideIndicator()
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    // Debug: Print raw response
                    if let rawResponse = String(data: data, encoding: .utf8) {
                        debugPrint("📦 Raw Response: \(rawResponse)")
                    }

                    do {
                        let response = try JSONDecoder().decode(TripPrepaymentResponse.self, from: data)

                        if response.status == false {
                            self.failureCheckoutUrl?(response.errorMessage ?? "Failed to create prepayment")
                            return
                        }

                        guard let checkoutUrl = response.data?.checkoutUrl, !checkoutUrl.isEmpty else {
                            self.failureCheckoutUrl?("Checkout URL not available")
                            return
                        }

                        // Store prepayment ID for status check
                        if let prepaymentId = response.data?.prepaymentId {
                            self.currentPrepaymentId = prepaymentId
                            debugPrint("Stored prepaymentId: \(prepaymentId)")
                        }

                        self.successCheckoutUrl?(checkoutUrl)
                    } catch {
                        debugPrint("Decoding error: \(error)")
                        self.failureCheckoutUrl?("Something went wrong")
                    }

                case .failure(let error):
                    self.failureCheckoutUrl?(error.localizedDescription)
                }
            }
    }

    // MARK: - Check Prepayment Status
    func getPrepaymentId() -> Int? {
        return currentPrepaymentId
    }

    func checkPaymentStatus() {
        guard let prepaymentId = currentPrepaymentId else {
            debugPrint("❌ checkPaymentStatus: currentPrepaymentId is nil")
            failurePaymentStatus?("No payment found. Please try again.")
            return
        }

        debugPrint("✅ checkPaymentStatus: prepaymentId = \(prepaymentId)")
        APIClient.sharedInstance.showIndicaor()

        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.tripPrepayments,
            parameters: [:],
            pathComponent: "/\(prepaymentId)",
            responseType: TripPrepaymentResponse.self,
            parameterEncoding: .url) { [weak self] response, error, statusCode in
                debugPrint("⬅️ Payment Status - statusCode: \(statusCode ?? -1), error: \(error ?? "nil")")
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
                    self.failurePaymentStatus?(response.errorMessage ?? "Payment verification failed")
                    return
                }

                // Check payment status using isPaid or paymentStatus
                let isPaid = response.data?.isPaid ?? false
                let paymentStatus = response.data?.paymentStatus?.lowercased() ?? ""
                debugPrint("Payment Status: isPaid=\(isPaid), paymentStatus=\(paymentStatus)")

                if isPaid || paymentStatus == "paid" || paymentStatus == "completed" || paymentStatus == "success" || paymentStatus == "succeeded" {
                    self.successPaymentStatus?()
                } else if paymentStatus == "pending" {
                    self.failurePaymentStatus?("Payment is still pending. Please complete the payment.")
                } else if paymentStatus == "failed" {
                    let failureMsg = response.data?.failureMessage ?? "Payment failed. Please try again."
                    self.failurePaymentStatus?(failureMsg)
                } else {
                    self.failurePaymentStatus?("Payment not completed")
                }
            }
    }
}

// MARK: - Trip Prepayment Response Model
struct TripPrepaymentResponse: Codable {
    var status: Bool?
    var message: String?
    var data: TripPrepaymentData?
    var errors: String?

    var errorMessage: String? {
        return message
    }
}

struct TripPrepaymentData: Codable {
    var prepaymentId: Int?
    var publicToken: String?
    var customerName: String?
    var paymentStatus: String?
    var requestStatus: String?
    var totalAmount: Double?
    var depositAmount: Double?
    var remainingAmount: Double?
    var currency: String?
    var canCreateBooking: Bool?
    var isPaid: Bool?
    var isConverted: Bool?
    var convertedBookingId: Int?
    var convertedBookingUrl: String?
    var paidAt: String?
    var expiresAt: String?
    var failureMessage: String?
    var stripeStatus: String?
    var checkoutUrl: String?

    enum CodingKeys: String, CodingKey {
        case prepaymentId = "prepayment_id"
        case publicToken = "public_token"
        case customerName = "customer_name"
        case paymentStatus = "payment_status"
        case requestStatus = "request_status"
        case totalAmount = "total_amount"
        case depositAmount = "deposit_amount"
        case remainingAmount = "remaining_amount"
        case currency
        case canCreateBooking = "can_create_booking"
        case isPaid = "is_paid"
        case isConverted = "is_converted"
        case convertedBookingId = "converted_booking_id"
        case convertedBookingUrl = "converted_booking_url"
        case paidAt = "paid_at"
        case expiresAt = "expires_at"
        case failureMessage = "failure_message"
        case stripeStatus = "stripe_status"
        case checkoutUrl = "checkout_url"
    }
}
