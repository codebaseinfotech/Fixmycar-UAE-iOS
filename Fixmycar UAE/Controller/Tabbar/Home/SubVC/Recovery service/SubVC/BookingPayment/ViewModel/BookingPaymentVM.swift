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
                            self.failureCreateBooking?(response.message ?? "")
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
                    self.failureCreateBooking?(response.message ?? "Failed")
                    return
                }
                
                self.successCreateBooking?()
            }
        
    }
}
