//
//  PendingJobVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 03/03/26.
//

import UIKit
import GoogleMaps

class PendingJobVC: UIViewController {
    
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewBottomPopup: UIView!
    @IBOutlet weak var viewLoader: FindingDriverLoaderView!
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet weak var svCallUs: UIStackView!
    @IBOutlet weak var svYesorNo: UIStackView!
    
    private var mapView: GMSMapView!
    private var pickupMarker: GMSMarker?
    private var dropMarker: GMSMarker?
    private var routePolyline: GMSPolyline?
    
    var activeBookingId: Int = 0
    
    let bookingVM = BookingDetailsVM()
    var supportVM = JumpStartVM()
    var cancelBookingVM = CancelBookingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBottomPopup.layer.cornerRadius = 20
        viewBottomPopup.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        setupGoogleMap()
        fetchBookingAndShowRoute()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        supportVM.getSupportDetails()
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        viewLoader.isHidden = true
        svCallUs.isHidden = true
        svYesorNo.isHidden = false
        lblDis.text = "Are you sure you want to cancel this request"
    }
    
    @IBAction func tappedCallUs(_ sender: Any) {
        callSupport()
    }
    
    @IBAction func tappedNo(_ sender: Any) {
        viewLoader.isHidden = false
        svCallUs.isHidden = false
        svYesorNo.isHidden = true
        lblDis.text = "Please wait while we look for available drivers"
    }
    
    @IBAction func tappedYes(_ sender: Any) {
        cancelBookingVM.bookingCancel(bookingId: activeBookingId, reasonId: 1, notes: "Test")
        cancelBookingVM.successCancelBooking = { msg in
            AppDelegate.appDelegate.setUpHome()
            self.setUpMakeToast(msg: msg)
            
        }
        cancelBookingVM.failureCancelBooking = { msg in
            self.setUpMakeToast(msg: msg)
        }
    }
    
    func setupGoogleMap() {
        // no fixed city, just temporary camera
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1)
        mapView = GMSMapView(frame: viewMap.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewMap.addSubview(mapView)
    }
    
    func callSupport() {
        guard let data = supportVM.supportDetails else {
            self.setUpMakeToast(msg: "Support data not loaded")
            return
        }
        
        // Remove + and spaces from number (same as JumpStartVC)
        let phone = data.phoneNumber
        
        guard let url = URL(string: "tel://\(phone)") else {
            self.setUpMakeToast(msg: "Invalid phone number")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            self.setUpMakeToast(msg: "Unable to make a call on this device")
        }
    }
    
}

extension PendingJobVC {
    
    func fetchBookingAndShowRoute() {
        bookingVM.bookingid = activeBookingId
        
        bookingVM.successBookingDetails = { [weak self] in
            guard let self else { return }
            guard let d = self.bookingVM.bookingDetails else { return }
            
            let pLat = Double(d.pickupLat ?? "") ?? 0
            let pLng = Double(d.pickupLng ?? "") ?? 0
            let dLat = Double(d.dropoffLat ?? "") ?? 0
            let dLng = Double(d.dropoffLng ?? "") ?? 0
            
            guard pLat != 0, pLng != 0, dLat != 0, dLng != 0 else {
                debugPrint("❌ Missing pickup/drop coords in booking details")
                return
            }
            
            let pickup = CLLocationCoordinate2D(latitude: pLat, longitude: pLng)
            let drop = CLLocationCoordinate2D(latitude: dLat, longitude: dLng)
            
            self.showPickupDropAndRoute(pickup: pickup, drop: drop)
        }
        
        bookingVM.failureBookingDetails = { [weak self] msg in
            debugPrint("❌ Booking details failed:", msg)
            // self?.setUpMakeToast(msg: msg) // if you want
        }
        
        bookingVM.getBookingDetails()
    }
    
    func showPickupDropAndRoute(pickup: CLLocationCoordinate2D, drop: CLLocationCoordinate2D) {
        // Markers
        pickupMarker?.map = nil
        let pm = GMSMarker(position: pickup)
        pm.title = "Pickup"
        pm.icon = UIImage(named: "pickup_pin")
        pm.map = mapView
        pickupMarker = pm
        
        dropMarker?.map = nil
        let dm = GMSMarker(position: drop)
        dm.title = "Drop"
        dm.icon = UIImage(named: "drop_pin")
        dm.map = mapView
        dropMarker = dm
        
        // Fit both points
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(pickup)
        bounds = bounds.includingCoordinate(drop)
        
        let padding = UIEdgeInsets(top: 80, left: 40, bottom: 260, right: 40)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: padding))
        
        self.drawRoute(resultPolyline: self.bookingVM.bookingDetails?.routePolyline ?? "")

        // Route polyline
//        drawRoute(from: pickup, to: drop)
    }
    
    func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        routePolyline?.map = nil
        
        var comps = URLComponents(string: "https://maps.googleapis.com/maps/api/directions/json")!
        comps.queryItems = [
            .init(name: "origin", value: "\(from.latitude),\(from.longitude)"),
            .init(name: "destination", value: "\(to.latitude),\(to.longitude)"),
            .init(name: "mode", value: "driving"),
            .init(name: "departure_time", value: "now"),
            .init(name: "key", value: google_place_key)
        ]
        
        guard let url = comps.url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let routes = json?["routes"] as? [[String: Any]]
            let poly = routes?.first?["overview_polyline"] as? [String: Any]
            let points = poly?["points"] as? String
            
            guard let points, let path = GMSPath(fromEncodedPath: points) else {
                debugPrint("❌ No polyline points found")
                return
            }
            
            DispatchQueue.main.async {
                let pl = GMSPolyline(path: path)
                pl.strokeWidth = 5
                pl.strokeColor = .primeryBlack
                pl.map = self.mapView
                self.routePolyline = pl
            }
        }.resume()
    }
    
    func drawRoute(resultPolyline: String?) {
        // old polyline remove
        //            routePolyline?.map = nil
        //            routePolyline = nil
        guard let encoded = resultPolyline,
              !encoded.isEmpty,
              let path = GMSPath(fromEncodedPath: encoded) else {
            return
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 4
        polyline.geodesic = true
        polyline.map = mapView
        //            routePolyline = polyline
        // fit bounds like Laravel/JS
        var bounds = GMSCoordinateBounds()
        for i in 0..<path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: i))
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 40)
        mapView.animate(with: update)
    }

}
