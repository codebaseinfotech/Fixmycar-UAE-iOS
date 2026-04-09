//
//  BookingPaymentVM.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 16/02/26.
//

import Foundation

class BookingPaymentVM {
    var successCreateBooking: (() -> Void)?
    var failureCreateBooking: ((String) -> Void)?

    var successCheckoutUrl: ((String) -> Void)?
    var failureCheckoutUrl: ((String) -> Void)?

    private var currentServiceRequestId: Int?
    private var currentPaymentAmount: Double?
    
    func createBookingImg() {
        APIClient.sharedInstance.showIndicaor()
        
        var params: [String: Any] = [
            "service_type_id": CreateBooking.shared.service_type_id,
            "pickup_address": CreateBooking.shared.pickup_address ?? "",
            "dropoff_address": CreateBooking.shared.dropoff_address ?? "",
            "distance_km": CreateBooking.shared.distance_km ?? 0.0,
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0,
            "dropoff_lat": CreateBooking.shared.dropoff_lat ?? 0.0,
            "dropoff_lng": CreateBooking.shared.dropoff_lng ?? 0.0,
            "booking_type": CreateBooking.shared.booking_type ?? "",
            "vehicle_type": CreateBooking.shared.vehicle_type ?? "",
            "issue": CreateBooking.shared.issue ?? "",
            "additional_notes": CreateBooking.shared.additional_notes ?? "",
            "eta_minutes": CreateBooking.shared.eta_minutes ?? "",
            "discountPrice": CreateBooking.shared.discountPrice ?? "",
            "total_price": CreateBooking.shared.finalPrice ?? "",
            "platform_fee": CreateBooking.shared.platform_fee ?? "",
            "tax": CreateBooking.shared.tax ?? "",
            "price": CreateBooking.shared.price ?? "",
            "route_polyline": CreateBooking.shared.route_polyline ?? "",
            "vehicle_model": CreateBooking.shared.vehicle_model ?? "",
            "vehicle_make": CreateBooking.shared.vehicle_make ?? "",
            "payment_method": CreateBooking.shared.payment_method ?? ""
        ]
        
        if CreateBooking.shared.promotion_id != 0 {
            params["promotion_id"] = CreateBooking.shared.promotion_id
        }
        
        if CreateBooking.shared.isScheduleBooking {
            let date = CreateBooking.shared.scheduled_at?.toDisplayDate(apiFormat: "dd MMM yyyy hh:mm a", displayFormat: "yyyy-MM-dd HH:mm:ss")
            params["scheduled_at"] = date
        }
        
        debugPrint("Create Booking Param: ", params)
        
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
        
        APIClient.sharedInstance.uploadMultipart(
            urlString: APIEndPoint.bookingList,
            parameters: params,
            files: files) { result in
                switch result {
                case .success(let data):
                    APIClient.sharedInstance.hideIndicator()
                    do {
                        let response = try JSONDecoder().decode(BookingResponseModel.self, from: data)

                        if response.status == true {
                            self.successCreateBooking?()
                        } else {
                            self.failureCreateBooking?(response.errorMessage ?? "Something went wrong")
                        }
                        
                    } catch {
                        self.failureCreateBooking?(error.localizedDescription)
                    }
                case .failure(let error):
                    APIClient.sharedInstance.hideIndicator()
                    self.failureCreateBooking?(error.localizedDescription)
                }
            }
        
    }
    
    func createBooking() {
        APIClient.sharedInstance.showIndicaor()
        
        var params: [String: Any] = [
            "service_type_id": CreateBooking.shared.service_type_id,
            "pickup_address": CreateBooking.shared.pickup_address ?? "",
            "dropoff_address": CreateBooking.shared.dropoff_address ?? "",
            "distance_km": CreateBooking.shared.distance_km ?? 0.0,
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0,
            "dropoff_lat": CreateBooking.shared.dropoff_lat ?? 0.0,
            "dropoff_lng": CreateBooking.shared.dropoff_lng ?? 0.0,
            "booking_type": CreateBooking.shared.booking_type ?? "",
            "vehicle_type": CreateBooking.shared.vehicle_type ?? "",
            "issue": CreateBooking.shared.issue ?? "",
            "additional_notes": CreateBooking.shared.additional_notes ?? "",
            "eta_minutes": CreateBooking.shared.eta_minutes ?? "",
            "discountPrice": CreateBooking.shared.discountPrice ?? "",
            "total_price": CreateBooking.shared.finalPrice ?? "",
            "platform_fee": CreateBooking.shared.platform_fee ?? "",
            "tax": CreateBooking.shared.tax ?? "",
            "price": CreateBooking.shared.price ?? "",
            "route_polyline": CreateBooking.shared.route_polyline ?? "",
            "vehicle_model": CreateBooking.shared.vehicle_model ?? "",
            "vehicle_make": CreateBooking.shared.vehicle_make ?? "",
            "payment_method": CreateBooking.shared.payment_method ?? ""
        ]
        
        if CreateBooking.shared.promotion_id != 0 {
            params["promotion_id"] = CreateBooking.shared.promotion_id
        }
        
        if CreateBooking.shared.isScheduleBooking {
            let date = CreateBooking.shared.scheduled_at?.toDisplayDate(apiFormat: "dd MMM yyyy hh:mm a", displayFormat: "yyyy-MM-dd HH:mm:ss")
            params["scheduled_at"] = date
        }
        
        debugPrint("Create Booking Param: ", params)
        
        APIClient.sharedInstance.request(
            method: .post,
            url: APIEndPoint.bookingList,
            parameters: params,
            responseType: BookingResponseModel.self) { [weak self] response, error, statusCode in
                APIClient.sharedInstance.hideIndicator()
                guard let self = self else { return }
                
                // 🔴 If error
                if let error = error {
                    self.failureCreateBooking?(error)
                    return
                }
                
                // 🔴 If response is nil
                guard let response = response else {
                    self.failureCreateBooking?("Something went wrong")
                    return
                }
                
                // 🔴 If API status false
                if response.status == false {
                    self.failureCreateBooking?(response.errorMessage ?? "Failed")
                    return
                }
                
                self.successCreateBooking?()
            }
    }

    // MARK: - Step 1: Create Booking and Get Checkout URL
    func getStripeCheckoutUrl(amount: Double) {
        currentPaymentAmount = amount
        APIClient.sharedInstance.showIndicaor()

        var params: [String: Any] = [
            "service_type_id": CreateBooking.shared.service_type_id,
            "pickup_address": CreateBooking.shared.pickup_address ?? "",
            "dropoff_address": CreateBooking.shared.dropoff_address ?? "",
            "distance_km": CreateBooking.shared.distance_km ?? 0.0,
            "pickup_lat": CreateBooking.shared.pickup_lat ?? 0.0,
            "pickup_lng": CreateBooking.shared.pickup_lng ?? 0.0,
            "dropoff_lat": CreateBooking.shared.dropoff_lat ?? 0.0,
            "dropoff_lng": CreateBooking.shared.dropoff_lng ?? 0.0,
            "booking_type": CreateBooking.shared.booking_type ?? "",
            "vehicle_type": CreateBooking.shared.vehicle_type ?? "",
            "issue": CreateBooking.shared.issue ?? "",
            "additional_notes": CreateBooking.shared.additional_notes ?? "",
            "eta_minutes": CreateBooking.shared.eta_minutes ?? "",
            "discountPrice": CreateBooking.shared.discountPrice ?? "",
            "total_price": CreateBooking.shared.finalPrice ?? "",
            "platform_fee": CreateBooking.shared.platform_fee ?? "",
            "tax": CreateBooking.shared.tax ?? "",
            "price": CreateBooking.shared.price ?? "",
            "route_polyline": CreateBooking.shared.route_polyline ?? "",
            "vehicle_model": CreateBooking.shared.vehicle_model ?? "",
            "vehicle_make": CreateBooking.shared.vehicle_make ?? "",
            "payment_method": CreateBooking.shared.payment_method ?? ""
        ]

        if CreateBooking.shared.promotion_id != 0 {
            params["promotion_id"] = CreateBooking.shared.promotion_id
        }

        if CreateBooking.shared.isScheduleBooking {
            let date = CreateBooking.shared.scheduled_at?.toDisplayDate(apiFormat: "dd MMM yyyy hh:mm a", displayFormat: "yyyy-MM-dd HH:mm:ss")
            params["scheduled_at"] = date
        }

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

        // Step 1: Create booking first to get service_request_id
        APIClient.sharedInstance.uploadMultipart(
            urlString: APIEndPoint.bookingList,
            parameters: params,
            files: files) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(BookingResponseModel.self, from: data)

                        if response.status == true, let bookingId = response.data?.bookingId ?? response.data?.details?.id {
                            self.currentServiceRequestId = bookingId
                            // Step 2: Get checkout URL
                            self.fetchCheckoutUrl(serviceRequestId: bookingId, amount: amount)
                        } else {
                            APIClient.sharedInstance.hideIndicator()
                            self.failureCheckoutUrl?(response.errorMessage ?? "Failed to create booking")
                        }
                    } catch {
                        APIClient.sharedInstance.hideIndicator()
                        self.failureCheckoutUrl?(error.localizedDescription)
                    }
                case .failure(let error):
                    APIClient.sharedInstance.hideIndicator()
                    self.failureCheckoutUrl?(error.localizedDescription)
                }
            }
    }

    // MARK: - Step 2: Fetch Stripe Checkout URL
    private func fetchCheckoutUrl(serviceRequestId: Int, amount: Double) {
        let params: [String: Any] = [
            "service_request_id": serviceRequestId,
            "amount": amount
        ]

        debugPrint("Checkout URL Params: ", params)

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
                    self.failureCheckoutUrl?(response.errorMessage ?? "Failed to get checkout URL")
                    return
                }

                guard let checkoutUrl = response.data?.checkoutUrl, !checkoutUrl.isEmpty else {
                    self.failureCheckoutUrl?("Checkout URL not available")
                    return
                }

                // Store service_request_id from checkout response as fallback
                if let serviceId = response.data?.serviceRequestId {
                    self.currentServiceRequestId = serviceId
                    debugPrint("Stored serviceRequestId from checkout: \(serviceId)")
                }

                self.successCheckoutUrl?(checkoutUrl)
            }
    }

    // MARK: - Step 3: Check Payment Status
    var successPaymentStatus: (() -> Void)?
    var failurePaymentStatus: ((String) -> Void)?

    func getServiceRequestId() -> Int? {
        return currentServiceRequestId
    }

    func checkPaymentStatus() {
        // Use stored ID or get from checkout response
        let serviceRequestId: Int
        if let storedId = currentServiceRequestId {
            serviceRequestId = storedId
            debugPrint("✅ Using stored serviceRequestId: \(storedId)")
        } else {
            debugPrint("❌ checkPaymentStatus: currentServiceRequestId is nil")
            failurePaymentStatus?("No booking found. Please try again.")
            return
        }

        let urlPath = "\(serviceRequestId)/status"
        debugPrint("✅ checkPaymentStatus: serviceRequestId = \(serviceRequestId)")
        debugPrint("✅ Full URL path: \(APIEndPoint.paymentStatus.rawValue)\(urlPath)")
        APIClient.sharedInstance.showIndicaor()

        APIClient.sharedInstance.request(
            method: .get,
            url: APIEndPoint.paymentStatus,
            parameters: [:],
            pathComponent: urlPath,
            responseType: PaymentStatusResponse.self,
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

                debugPrint("Payment Status Response: isPaid=\(response.data?.isPaid ?? false), isPartialPaid=\(response.data?.isPartialPaid ?? false), latestStatus=\(response.data?.latestPayment?.status ?? "nil")")

                // Check payment status using isPaid or isPartialPaid
                if response.data?.isPaid == true || response.data?.isPartialPaid == true {
                    self.successPaymentStatus?()
                } else {
                    // Check latest payment status
                    let latestStatus = response.data?.latestPayment?.status?.lowercased() ?? ""
                    if latestStatus == "paid" || latestStatus == "completed" || latestStatus == "success" || latestStatus == "succeeded" {
                        self.successPaymentStatus?()
                    } else if latestStatus == "pending" {
                        self.failurePaymentStatus?("Payment is still pending. Please complete the payment.")
                    } else if latestStatus == "failed" {
                        let failureMsg = response.data?.latestPayment?.failureMessage ?? "Payment failed"
                        self.failurePaymentStatus?(failureMsg)
                    } else {
                        self.failurePaymentStatus?("Payment not completed")
                    }
                }
            }
    }
}
