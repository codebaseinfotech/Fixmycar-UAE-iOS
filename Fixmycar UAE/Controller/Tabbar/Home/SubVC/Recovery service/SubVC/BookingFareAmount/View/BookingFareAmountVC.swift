//
//  BookingFareAmountVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 26/01/26.
//

import UIKit
import GoogleMaps

class BookingFareAmountVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblEstimatedTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtPickup: UITextField!
    @IBOutlet weak var txtDrop: UITextField!
    
    var viewModel = BookingFareAmountVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPickup.text = CreateBooking.shared.pickup_address
        txtDrop.text = CreateBooking.shared.dropoff_address
         
        setupMap()
        addMarkers()
        drawRoute()
        
        print("pickup_lat", CreateBooking.shared.pickup_lat ?? 0.0)
        print("pickup_lng", CreateBooking.shared.pickup_lng ?? 0.0)
        print("dropoff_lat", CreateBooking.shared.dropoff_lat ?? 0.0)
        print("dropoff_lng", CreateBooking.shared.dropoff_lng ?? 0.0)

        calculateDistance()
        
        viewModel.successCalculatePrice = {
            let rounded = Double(String(format: "%.3f", self.viewModel.priceData?.distanceKm ?? 0.0))!
            self.lblDistance.text = "Distance:" + " \(rounded) km"
            
            self.lblPrice.text = "\(self.viewModel.priceData?.currency ?? "") \(self.viewModel.priceData?.price ?? "")"

            CreateBooking.shared.price = self.viewModel.priceData?.price ?? ""
            CreateBooking.shared.currency = self.viewModel.priceData?.currency ?? ""
            CreateBooking.shared.distance_km = self.viewModel.priceData?.distanceKm ?? 0.0
            
            self.viewModel.getAvailableDrivers()
        }
        viewModel.failureCalculatePrice = { msg in
            self.setUpMakeToast(msg: msg)
        }
        
        viewModel.successAvailableDrivers = {
            self.showDriversOnMap(drivers: self.viewModel.availableDrivers)
        }
        viewModel.failureAvailableDrivers = { msg in
            self.setUpMakeToast(msg: msg)
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - calculateDistance
    func calculateDistance() {
        
        let pickup = CLLocation(latitude: CreateBooking.shared.pickup_lat ?? 0.0, longitude: CreateBooking.shared.pickup_lng ?? 0.0)
        let drop = CLLocation(latitude: CreateBooking.shared.dropoff_lat ?? 0.0, longitude: CreateBooking.shared.dropoff_lng ?? 0.0)
        
        let distanceInMeters = pickup.distance(from: drop)
        let distanceInKM = distanceInMeters / 1000.0
        
        print("Distance: \(distanceInKM) KM")
        viewModel.getCalculatePrice(km: distanceInKM)
    }
    
    func showDriversOnMap(drivers: [DriverData]) {
        
        for driver in drivers {
            
            guard
                let lat = driver.location?.latitude,
                let lng = driver.location?.longitude
            else { continue }
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//            marker.title = driver.fullName ?? "Driver"
//            marker.snippet = "Distance: \(driver.distanceKm ?? 0) km | ETA: \(driver.estimatedTime ?? "")"
            
            // Custom driver icon (optional)
            marker.icon = UIImage(named: "ic_driver") // Add car icon in Assets
            
            marker.map = mapView
        }
    }
    
    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedContinue(_ sender: Any) {
        if viewModel.isScheduleBooking {
            let vc = FareBreakupVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = BookingConfirmationPopupVC()
            if let sheet = vc.sheetPresentationController {
                // Create a custom detent that returns a fixed height
                let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                    return 200
                }
                sheet.detents = [fixedDetent]
                sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
            }
            vc.sheetPresentationController?.delegate = self
            vc.isConfirmSchedule = false
            
            vc.onTappedConfirmBooking = {
                let vc = FareBreakupVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.present(vc, animated: true)
        }
        
    }
    
    // MARK: - setUp Map
    func setupMap() {
        let camera = GMSCameraPosition.camera(
            withLatitude: CreateBooking.shared.pickup_lat ?? 0.0,
            longitude: CreateBooking.shared.pickup_lng ?? 0.0,
            zoom: 14
        )
        mapView.camera = camera
    }
    
    func addMarkers() {

        let pickupMarker = GMSMarker()
        pickupMarker.position = CLLocationCoordinate2D(
            latitude: CreateBooking.shared.pickup_lat ?? 0.0,
            longitude: CreateBooking.shared.pickup_lng ?? 0.0
        )
        pickupMarker.title = "Pickup"
        pickupMarker.icon = GMSMarker.markerImage(with: .green)
        pickupMarker.map = mapView

        let dropMarker = GMSMarker()
        dropMarker.position = CLLocationCoordinate2D(
            latitude: CreateBooking.shared.dropoff_lat ?? 0.0,
            longitude: CreateBooking.shared.dropoff_lng ?? 0.0
        )
        dropMarker.title = "Drop"
        dropMarker.icon = GMSMarker.markerImage(with: .red)
        dropMarker.map = mapView
    }

    func drawRoute() {

        let origin = "\(CreateBooking.shared.pickup_lat ?? 0.0),\(CreateBooking.shared.pickup_lng ?? 0.0)"
        let destination = "\(CreateBooking.shared.dropoff_lat ?? 0.0),\(CreateBooking.shared.dropoff_lng ?? 0.0)"

        let urlString =
        "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(google_place_key)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let routes = json["routes"] as? [[String: Any]],
                let route = routes.first,
                let overviewPolyline = route["overview_polyline"] as? [String: Any],
                let points = overviewPolyline["points"] as? String,
                let legs = route["legs"] as? [[String: Any]],
                let leg = legs.first,
                let duration = leg["duration"] as? [String: Any],
                let durationText = duration["text"] as? String
            else {
                return
            }

            DispatchQueue.main.async {
                var titleEstimetedTime = ""
                if durationText.contains("mins") == true {
                    titleEstimetedTime = "Estimated time taken: \(durationText)"
                } else {
                    titleEstimetedTime = "Estimated time taken: \(durationText) minutes"
                }
                self.lblEstimatedTime.text = titleEstimetedTime
                self.showPolyline(encodedPath: points)
            }
        }.resume()
    }
    
    func showPolyline(encodedPath: String) {

        let path = GMSPath(fromEncodedPath: encodedPath)
        let polyline = GMSPolyline(path: path)

        polyline.strokeWidth = 5
        polyline.strokeColor = .primeryBlack
        polyline.map = mapView

        // Adjust camera to fit route
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(
            CLLocationCoordinate2D(latitude: CreateBooking.shared.pickup_lat ?? 0.0, longitude: CreateBooking.shared.pickup_lng ?? 0.0)
        )
        bounds = bounds.includingCoordinate(
            CLLocationCoordinate2D(latitude: CreateBooking.shared.dropoff_lat ?? 0.0, longitude: CreateBooking.shared.dropoff_lng ?? 0.0)
        )

        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
    }


    
    

}

// MARK: - UISheetPresentationControllerDelegate
extension BookingFareAmountVC: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let overlayView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                overlayView.alpha = 0
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
            
        }
    }
}
