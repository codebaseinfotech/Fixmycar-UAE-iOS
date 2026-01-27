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
    @IBOutlet weak var txtPickup: UITextField! {
        didSet {
            txtPickup.text = viewModel.pickUpAddress
        }
    }
    @IBOutlet weak var txtDrop: UITextField! {
        didSet {
            txtDrop.text = viewModel.dropAddress
        }
    }
    
    var viewModel = BookingFareAmountVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            vc.isConfirmSchedule = true
            
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
            withLatitude: viewModel.pickUpLatitude,
            longitude: viewModel.pickUpLongitude,
            zoom: 14
        )
        mapView.camera = camera
    }
    
    func addMarkers() {

        let pickupMarker = GMSMarker()
        pickupMarker.position = CLLocationCoordinate2D(
            latitude: viewModel.pickUpLatitude,
            longitude: viewModel.pickUpLongitude
        )
        pickupMarker.title = "Pickup"
        pickupMarker.icon = GMSMarker.markerImage(with: .green)
        pickupMarker.map = mapView

        let dropMarker = GMSMarker()
        dropMarker.position = CLLocationCoordinate2D(
            latitude: viewModel.dropLatitude,
            longitude: viewModel.dropLongitude
        )
        dropMarker.title = "Drop"
        dropMarker.icon = GMSMarker.markerImage(with: .red)
        dropMarker.map = mapView
    }

    func drawRoute() {

        let origin = "\(viewModel.pickUpLatitude),\(viewModel.pickUpLongitude)"
        let destination = "\(viewModel.dropLatitude),\(viewModel.dropLongitude)"

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
                let points = overviewPolyline["points"] as? String
            else {
                return
            }

            DispatchQueue.main.async {
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
            CLLocationCoordinate2D(latitude: viewModel.pickUpLatitude, longitude: viewModel.pickUpLongitude)
        )
        bounds = bounds.includingCoordinate(
            CLLocationCoordinate2D(latitude: viewModel.dropLatitude, longitude: viewModel.dropLongitude)
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
