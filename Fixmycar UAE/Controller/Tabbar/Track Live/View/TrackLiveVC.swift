    //
    //  TrackLiveVC.swift
    //  Fixmycar UAE
    //
    //  Created by iMac on 23/01/26.
    //

    import UIKit
    import GoogleMaps
    import CoreLocation

    class TrackLiveVC: UIViewController {

        @IBOutlet weak var viewMap: UIView!
        @IBOutlet weak var lblTitle: AppLabel!
        @IBOutlet weak var lblTimeDis: AppLabel!
        @IBOutlet weak var imgFilledRoad: UIImageView!
        @IBOutlet weak var imgTruck: UIImageView!
        @IBOutlet weak var lblRemaining: AppLabel!
        @IBOutlet weak var lblRemainigAmount: AppLabel!
        @IBOutlet weak var btnPayNow: AppButton!
        @IBOutlet weak var imgUser: UIImageView!
        @IBOutlet weak var lblUserName: AppLabel!
        @IBOutlet weak var lblPlateNumber: AppLabel!
        @IBOutlet weak var lblCarName: AppLabel!
        @IBOutlet weak var lblRate: AppLabel!
        
        @IBOutlet weak var viewNoTrackFound: UIView! {
            didSet {
                viewNoTrackFound.isHidden = true
            }
        }
        @IBOutlet weak var lblFirstStatus: AppLabel!
        @IBOutlet weak var lblSecondStatus: AppLabel!
        @IBOutlet weak var lblTherdStatus: AppLabel!
        
        @IBOutlet weak var viewCall: UIView!
        @IBOutlet weak var viewChat: UIView!
        @IBOutlet weak var viewMain: AllSideCornerView!
        @IBOutlet weak var viewMainTop: NSLayoutConstraint!
        @IBOutlet weak var svTitleDetails: UIStackView!
        
        @IBOutlet weak var progressContainer: UIView!
        @IBOutlet weak var filledWidthConstraint: NSLayoutConstraint!
        @IBOutlet weak var truckLeadingConstraint: NSLayoutConstraint!
        
        // MARK: - Markers & Route
        private var mapView: GMSMapView!
        private let locationManager = CLLocationManager()
        
        private var routePolyline: GMSPolyline?
        private var driverMarker: GMSMarker?
        
        private var pickupMarker: GMSMarker?
        private var dropMarker: GMSMarker?
        private var currentDriverCoordinate: CLLocationCoordinate2D?
        var polyline: GMSPolyline?
        
        var collapsedTop: CGFloat {
            view.safeAreaLayoutGuide.layoutFrame.height * 0.15
        }
        
        var expandedTop: CGFloat {
            view.safeAreaLayoutGuide.layoutFrame.height * 0.55
        }
        
        var trackLiveVM = TrackLiveVM()
        
        // MARK: - view Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupLocation()
            
            setupGoogleMap()
            setupBottomSheet()
            viewMainTop.constant = collapsedTop
            
            trackLiveVM.getTrackLiveDetails()
            trackLiveVM.successTrackLive = {
                let dicData = self.trackLiveVM.trackBookingDetails
                self.updateProgressFromAPI(statusString: dicData?.status ?? "")
                self.setupMap()
                self.lblUserName.text = dicData?.driver?.name
                self.lblRate.text = "\(dicData?.driver?.rating ?? 0.0)"
                self.lblPlateNumber.text = dicData?.vehicleNumber
                self.lblCarName.text = dicData?.vehicleType ?? ""
                
                let jobStatus = dicData?.status
                if jobStatus == "PICKUP_COMPLETED" || jobStatus == "ON_THE_WAY_TO_DELIVERY" || jobStatus == "NEAR_DELIVERY" || jobStatus == "ARRIVED_AT_DELIVERY" {
                    self.lblFirstStatus.text = "At pickup"
                    self.lblSecondStatus.text = "On the way delivery"
                    self.lblTherdStatus.text = "Delivered"
                    
                    self.imgTruck.image = "ic_drop_truck".image
                } else {
                    self.lblFirstStatus.text = "Accepted"
                    self.lblSecondStatus.text = "On the way"
                    self.lblTherdStatus.text = "At pickup"
                    
                    self.imgTruck.image = "ic_truck".image
                }
            }
            trackLiveVM.failureTrackLive = { msg in
                self.setUpMakeToast(msg: msg)
            }
            
            
            // Do any additional setup after loading the view.
        }
        
        // MARK: - setUp Bottom Popup
        private func setupBottomSheet() {
            let panGesture = UIPanGestureRecognizer(
                target: self,
                action: #selector(handlePan(_:))
            )
            viewMain.addGestureRecognizer(panGesture)
        }
        
        
        @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            let velocity = gesture.velocity(in: view)
            
            switch gesture.state {
            case .changed:
                let newTop = viewMainTop.constant + translation.y
                viewMainTop.constant = min(
                    max(newTop, collapsedTop),
                    expandedTop
                )
                gesture.setTranslation(.zero, in: view)
                
            case .ended:
                let shouldExpand = velocity.y > 0
                animateBottomSheet(expand: shouldExpand)
                
            default:
                break
            }
        }
        
        
        private func animateBottomSheet(expand: Bool) {
            viewMainTop.constant = expand ? expandedTop : collapsedTop
            
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.85,
                initialSpringVelocity: 0.6,
                options: [.curveEaseOut]
            ) {
                self.view.layoutIfNeeded()
            }
            
            DispatchQueue.main.async { [self] in
                svTitleDetails.isHidden = expand ? true : false
            }
            
        }
        
        //MARK: - Action Method
        @IBAction func tappedChatWithDriver(_ sender: Any) {
        }
        
        @IBAction func tappedCall(_ sender: Any) {
        }
        @IBAction func tappedBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
        
        // MARK: - Setup Map
        private func setupLocation() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func setupGoogleMap() {

            let camera = GMSCameraPosition.camera(
                withLatitude: 23.1368,
                longitude: 72.5526,
                zoom: 16
            )

            mapView = GMSMapView(frame: viewMap.bounds, camera: camera)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewMap.addSubview(mapView)
        }
        
        private func setupMap() {
            //        mapView.isMyLocationEnabled = true
            //        mapView.settings.myLocationButton = true
            
            guard let booking = trackLiveVM.trackBookingDetails else { return }
            
            // Pickup Marker
            let pickup = CLLocationCoordinate2D(
                latitude: booking.pickupAddress?.lat ?? 0,
                longitude: booking.pickupAddress?.lng ?? 0
            )
            
            let drop = CLLocationCoordinate2D(
                latitude: booking.dropAddress?.lat ?? 0,
                longitude: booking.dropAddress?.lng ?? 0
            )
            
            let driver = CLLocationCoordinate2D(
                latitude: booking.driver?.location?.lat ?? 0,
                longitude: booking.driver?.location?.lng ?? 0
            )
            currentDriverCoordinate = driver
            
            let camera = GMSCameraPosition.camera(
                withTarget: driver,
                zoom: 16
            )
            mapView.animate(to: camera)
            
            if isDeliveryPhase(status: booking.status ?? "") {
                
                // 🚚 DELIVERY PHASE
                pickupMarker?.map = nil
                
                if dropMarker == nil {
                    dropMarker = GMSMarker(position: drop)
                    dropMarker?.icon = UIImage(named: "drop_pin")
                    dropMarker?.title = "Drop"
                    dropMarker?.map = mapView
                }
                
            } else {
                
                // 📍 PICKUP PHASE
                dropMarker?.map = nil
                
                if pickupMarker == nil {
                    pickupMarker = GMSMarker(position: pickup)
                    pickupMarker?.icon = UIImage(named: "pickup_pin")
                    pickupMarker?.title = "Pickup"
                    pickupMarker?.map = mapView
                }
            }
            
            updateDriverLocation(lat: booking.driver?.location?.lat ?? 0, lng: booking.driver?.location?.lng ?? 0, heading: 0)
            updateRoute()
            
            
        }
        
        func isDeliveryPhase(status: String) -> Bool {

            let deliveryStatuses = [
                "PICKUP_COMPLETED",
                "ON_THE_WAY_TO_DELIVERY",
                "NEAR_DELIVERY",
                "ARRIVED_AT_DELIVERY",
                "COMPLETED"
            ]

            return deliveryStatuses.contains(status)
        }

        func setCameraBounds(locations: [CLLocationCoordinate2D]) {

            var bounds = GMSCoordinateBounds()

            for location in locations {
                bounds = bounds.includingCoordinate(location)
            }

            let update = GMSCameraUpdate.fit(bounds, withPadding: 80)
            mapView.animate(with: update)
        }


        
        func addPickupMarker(position: CLLocationCoordinate2D) {
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "pickup_pin")
            marker.map = mapView
        }

        func addDropMarker(position: CLLocationCoordinate2D) {
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "drop_pin")
            marker.map = mapView
        }

        private func updateRoute() {

                guard let driver = currentDriverCoordinate,
                      let booking = trackLiveVM.trackBookingDetails else { return }

                routePolyline?.map = nil

                var destination: CLLocationCoordinate2D

                if booking.status == "PICKUP_COMPLETED" ||
                    booking.status == "ON_THE_WAY_TO_DELIVERY" ||
                    booking.status == "NEAR_DELIVERY" ||
                    booking.status == "ARRIVED_AT_DELIVERY" {

                    destination = CLLocationCoordinate2D(
                        latitude: booking.dropAddress?.lat ?? 0,
                        longitude: booking.dropAddress?.lng ?? 0
                    )

                } else {

                    destination = CLLocationCoordinate2D(
                        latitude: booking.pickupAddress?.lat ?? 0,
                        longitude: booking.pickupAddress?.lng ?? 0
                    )
                }

                drawRoute(from: driver, to: destination)
            }

        // MARK: - ROUTE (🔥 FIXED)
        func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {

            let urlStr =
            "https://maps.googleapis.com/maps/api/directions/json?origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&key=\(google_place_key)"

            guard let url = URL(string: urlStr) else { return }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }

                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                let routes = json?["routes"] as? [[String: Any]]
                let poly = routes?.first?["overview_polyline"] as? [String: Any]
                let points = poly?["points"] as? String

                guard let points else {
                    print("❌ No polyline points")
                    return
                }

                DispatchQueue.main.async {
                    self.polyline?.map = nil
                    let path = GMSPath(fromEncodedPath: points)
                    self.polyline = GMSPolyline(path: path)
                    self.polyline?.strokeWidth = 5
                    self.polyline?.strokeColor = .primeryBlack
                    self.polyline?.map = self.mapView
                }
            }.resume()
        }
        
        private func showPath(polyString: String) {

            routePolyline?.map = nil

            guard let path = GMSPath(fromEncodedPath: polyString) else { return }

            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = .primeryBlack
            polyline.map = mapView

            routePolyline = polyline
        }




        
        // MARK: - setUp Progress
        
        func animateProgress(to progress: CGFloat) {
            let clamped = min(max(progress, 0), 1)
            let totalWidth = progressContainer.frame.width
            let newX = totalWidth * clamped
            
            filledWidthConstraint.constant = newX
            
            let truckX = newX - (imgTruck.frame.width / 2)
            truckLeadingConstraint.constant = max(0, min(truckX, totalWidth - imgTruck.frame.width))
            
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            }
        }
        
        func updateProgressFromAPI(statusString: String) {
            let progress = progressValue(for: statusString)
            animateProgress(to: progress)
        }
        
        func progressValue(for status: String) -> CGFloat {
            switch status {
            case "ACCEPTED": return 0.0
            case "STARTED": return 0.25
            case "ON_THE_WAY_TO_PICKUP": return 0.50
            case "NEAR_PICKUP": return 0.75
            case "ARRIVED_AT_PICKUP": return 1.0
            case "PICKUP_COMPLETED": return 0.0
            case "ON_THE_WAY_TO_DELIVERY": return 0.50
            case "NEAR_DELIVERY": return 0.75
            case "ARRIVED_AT_DELIVERY": return 0.75
            case "COMPLETED": return 1.0
            default: return 0.0
            }
        }
        
        
    }

    // MARK: - CLLocationManagerDelegate

    extension TrackLiveVC: CLLocationManagerDelegate {

        func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {

            guard let location = locations.last else { return }

            let coordinate = location.coordinate
            let heading = location.course

    //        currentDriverCoordinate = coordinate

    //        updateDriverLocation(
    //            lat: coordinate.latitude,
    //            lng: coordinate.longitude,
    //            heading: heading
    //        )

        }
        func updateDriverLocation(lat: Double,
                                  lng: Double,
                                  heading: Double?) {

            let newPosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)

            if driverMarker == nil {
                driverMarker = GMSMarker(position: newPosition)
                driverMarker?.icon = UIImage(named: "ic_truck_1")
                driverMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                driverMarker?.isFlat = true
                driverMarker?.map = mapView
            }

            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)

            driverMarker?.position = newPosition
            driverMarker?.rotation = heading ?? 0

            CATransaction.commit()
        }

    }
