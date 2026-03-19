//
//  TrackLiveVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 23/01/26.
//

import UIKit
import GoogleMaps
import CoreLocation

class TrackLiveVC: UIViewController {
    
    @IBOutlet weak var viewMap: UIView! {
        didSet {
            viewMap.isHidden = true
        }
    }
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
    @IBOutlet weak var viewMain: AllSideCornerView! {
        didSet {
            viewMain.isHidden = true
        }
    }
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
    var googleMapVM = GoogleDistanceVM()
    
    private var currentBookingId: Int?

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()

        setupGoogleMap()
        setupBottomSheet()
        viewMainTop.constant = collapsedTop

        NotificationCenter.default.addObserver(self, selector: #selector(refreshBooking(_:)), name: NSNotification.Name.refrechData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBookingStatusUpdated(_:)), name: .bookingStatusUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSocketConnected), name: .socketConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDriverLocationUpdated(_:)), name: .driverLocationUpdated, object: nil)

        trackLiveVM.getTrackLiveDetails()
        trackLiveVM.successTrackLive = {
            let dicData = self.trackLiveVM.trackBookingDetails
            self.updateProgressFromAPI(statusString: dicData?.status ?? "")
            self.setupMap()
            self.lblTitle.text = "Your request is assigned to \(dicData?.driver?.name ?? "")"
            self.lblTimeDis.text = "Your ride request is assigned to the \(dicData?.driver?.name ?? ""). arriving soon for pick up."
            self.lblUserName.text = dicData?.driver?.name
            self.imgUser.loadFromUrlString(dicData?.driver?.image ?? "")
            self.lblRate.text = "\(dicData?.driver?.rating ?? 0.0)"
            self.lblCarName.text = dicData?.vehicleType ?? ""
            self.lblPlateNumber.text = dicData?.vehicleNumber
            self.lblCarName.text = dicData?.vehicleType ?? ""
            
            self.lblRemainigAmount.text = "AED" + " " + "\(dicData?.finalPrice ?? 0.0)"
            
            if !FMSocketManager.shared.isConnected {
                FMSocketManager.shared.connect()
            } else {
                // Already connected, join room directly
                if let bookingId = dicData?.bookingID {
                    FMSocketManager.shared.joinRoom(bookingId: bookingId)
                }
            }
            
            let jobStatus = dicData?.status
            if jobStatus == "pickup_completed" || jobStatus == "on_the_way_to_delivery" || jobStatus == "near_delivery" || jobStatus == "arrived_at_delivery" {
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
            self.setupDeliveryText(jobStatus: jobStatus ?? "")
            
            self.viewMain.isHidden = false
            self.viewMap.isHidden = false

            // Store booking ID and join socket room
            if let bookingId = dicData?.bookingID {
                self.currentBookingId = bookingId
                self.joinSocketRoomIfConnected()
            }
        }
        trackLiveVM.failureTrackLive = { msg in
            self.setUpMakeToast(msg: msg)
        }
        
        
        googleMapVM.successGoogleDistance = {
            self.setupDeliveryText(jobStatus: self.trackLiveVM.trackBookingDetails?.status ?? "")
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Leave socket room when leaving the screen
        if let bookingId = currentBookingId {
            FMSocketManager.shared.leaveRoom(bookingId: bookingId)
        }

        // Remove socket observers
        NotificationCenter.default.removeObserver(self, name: .socketConnected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .driverLocationUpdated, object: nil)
    }

    // MARK: - refreshBooking
    @objc func refreshBooking(_ notification: NSNotification){
        let type = notification.userInfo?["type"] as? String ?? ""
        if type == "trip_cancelled" || type == "trip_cancelled_by_admin" || type == "completed" {
            tappedBack(self)
        }
        trackLiveVM.getTrackLiveDetails()
    }

    // MARK: - setupTextDelivery
    func setupDeliveryText(jobStatus: String) {
        let jobStatus: JobStatus = JobStatus(rawValue: jobStatus) ?? .accepted
        let dicData = self.trackLiveVM.trackBookingDetails
        let timer = googleMapVM.dicResponse?.routes?.first?.legs?.first?.durationInTraffic?.text ?? ""

        var title = ""
        var subtitle = ""
        
        switch jobStatus {
        case .pending: break
        case .accepted:
            title = "Driver accepted your ride"
            subtitle = (dicData?.driver?.name ?? "") + " " + "has accepted your request and will arrive at" + " " + timer + "."

        case .started:
            title = "Your driver is arriving soon!"
            subtitle = "Your ride is booked." + " " + (dicData?.driver?.name ?? "") + " " + "will pick you up in" + " " + timer + "."
            
        case .onTheWayToPickup:
            title = "Driver is on the way"
            subtitle = (dicData?.driver?.name ?? "") + " " + "is heading to your pickup location. Pickup at" + " " + timer + "."
            
        case .nearPickup:
            title = "Driver is near your pickup"
            subtitle = (dicData?.driver?.name ?? "") + " " + "is almost there. Please be ready for pickup."
            
        case .arrivedAtPickup:
            title = "Driver has arrived"
            subtitle = (dicData?.driver?.name ?? "") + " " + "has arrived at your pickup location."
            
        case .pickupCompleted:
            title = "Pickup completed"
            subtitle = "You are on the way to your destination with" + " " + (dicData?.driver?.name ?? "") + "."
            
        case .onTheWayToDelivery:
            title = "Heading to destination"
            subtitle = (dicData?.driver?.name ?? "") + " " + "is driving you to your drop-off location."
            
        case .nearDelivery:
            title = "Almost at destination"
            subtitle = "You are near your drop-off point."
            
        case .arrivedAtDelivery:
            title = "Arrived at destination"
            subtitle = "You have reached your destination."
            
        case .completed:
            title = "Ride completed"
            subtitle = "Thank you for riding with us! Dropped at"
            
        case .cancelled: break
        }
        
        lblTitle.text = title
        lblTimeDis.text = subtitle
    }
    
    // MARK: - handleBookingStatusUpdated
    @objc func handleBookingStatusUpdated(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let bookingId = userInfo["booking_id"] as? Int else {
            return
        }

        // Only refresh if this is for the current booking
        if bookingId == trackLiveVM.trackBookingDetails?.bookingID {
            debugPrint("[SOCKET] Booking status updated for booking: \(bookingId)")
            trackLiveVM.getTrackLiveDetails()
        }
    }

    // MARK: - Socket Room Management
    @objc func handleSocketConnected() {
        debugPrint("[SOCKET] Socket connected - joining room if needed")
        joinSocketRoomIfConnected()
    }

    private func joinSocketRoomIfConnected() {
        guard let bookingId = currentBookingId else {
            debugPrint("[SOCKET] No booking ID to join room")
            return
        }

        if FMSocketManager.shared.isConnected {
            debugPrint("[SOCKET] Joining room for booking: \(bookingId)")
            FMSocketManager.shared.joinRoom(bookingId: bookingId)
        } else {
            debugPrint("[SOCKET] Socket not connected yet, will join when connected")
        }
    }

    // MARK: - Handle Driver Location Updated (Live Tracking)
    @objc func handleDriverLocationUpdated(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let bookingId = userInfo["booking_id"] as? Int,
              let lat = userInfo["lat"] as? Double,
              let lng = userInfo["lng"] as? Double else {
            return
        }

        // Only update if this is for the current booking
        guard bookingId == currentBookingId else { return }

        let heading = userInfo["heading"] as? Double ?? 0
        let speed = userInfo["speed"] as? Double ?? 0
        let route_polyline = userInfo["route_polyline"] as? String ?? ""
        debugPrint("Driver polylines: \(route_polyline)")

        debugPrint("[SOCKET] Driver location updated - lat: \(lat), lng: \(lng), heading: \(heading), speed: \(speed)")

        // Update driver marker position with animation
        currentDriverCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        updateDriverLocation(lat: lat, lng: lng, heading: heading)

        // Redraw route from new driver position
        updateRoute()
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
        let vc = UserChatVC()
        vc.chatDetailsVM.bookingId = trackLiveVM.trackBookingDetails?.bookingID ?? 0
        vc.profileName = trackLiveVM.trackBookingDetails?.driver?.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedCall(_ sender: Any) {
        callDriver()
    }
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Call Driver
    private func sanitizePhone(_ raw: String) -> String {
        let allowed = CharacterSet(charactersIn: "+0123456789")
        return raw.unicodeScalars.filter { allowed.contains($0) }.map(String.init).joined()
    }
    
    private func callDriver() {
        guard let phoneRaw = trackLiveVM.trackBookingDetails?.driver?.phone else {
            setUpMakeToast(msg: "Driver phone number not available")
            return
        }
        
        let phone = sanitizePhone(phoneRaw)
        
        guard !phone.isEmpty, let url = URL(string: "tel://\(phone)") else {
            setUpMakeToast(msg: "Invalid phone number")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            setUpMakeToast(msg: "Calling not supported on this device")
        }
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
            
            self.googleMapVM.getDistance(
                originLat: booking.driver?.location?.lat ?? 0,
                originLng: booking.driver?.location?.lng ?? 0,
                destLat: booking.dropAddress?.lat ?? 0,
                destLng: booking.dropAddress?.lng ?? 0)
            
        } else {
            
            // 📍 PICKUP PHASE
            dropMarker?.map = nil
            
            if pickupMarker == nil {
                pickupMarker = GMSMarker(position: pickup)
                pickupMarker?.icon = UIImage(named: "pickup_pin")
                pickupMarker?.title = "Pickup"
                pickupMarker?.map = mapView
            }
            
            self.googleMapVM.getDistance(
                originLat: booking.driver?.location?.lat ?? 0,
                originLng: booking.driver?.location?.lng ?? 0,
                destLat: booking.pickupAddress?.lat ?? 0,
                destLng: booking.pickupAddress?.lng ?? 0)
        }
        
        // Calculate heading from driver to destination
        let driverCoord = CLLocationCoordinate2D(
            latitude: booking.driver?.location?.lat ?? 0,
            longitude: booking.driver?.location?.lng ?? 0
        )

        let destinationCoord: CLLocationCoordinate2D
        if isDeliveryPhase(status: booking.status ?? "") {
            destinationCoord = drop
        } else {
            destinationCoord = pickup
        }

        let bearing = calculateBearing(from: driverCoord, to: destinationCoord)
        updateDriverLocation(lat: booking.driver?.location?.lat ?? 0, lng: booking.driver?.location?.lng ?? 0, heading: bearing)
        updateRoute()
        
        
    }
    
    func isDeliveryPhase(status: String) -> Bool {
        
        let deliveryStatuses = [
            "pickup_completed",
            "on_the_way_to_delivery",
            "near_delivery",
            "arrived_at_delivery",
            "completed"
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
        
        if booking.status == "pickup_completed" ||
            booking.status == "on_the_way_to_delivery" ||
            booking.status == "near_delivery" ||
            booking.status == "arrived_at_delivery" {
            
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
                debugPrint("❌ No polyline points")
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
        let progress = progressValue(for: JobStatus(rawValue: statusString)!)
        animateProgress(to: progress)
    }
    
    func progressValue(for status: JobStatus = .accepted) -> CGFloat {
        switch status {
        case .accepted: return 0.0
        case .started: return 0.25
        case .onTheWayToPickup: return 0.50
        case .nearPickup: return 0.75
        case .arrivedAtPickup: return 1.0
        case .pickupCompleted: return 0.0
        case .onTheWayToDelivery: return 0.50
        case .nearDelivery: return 0.75
        case .arrivedAtDelivery: return 0.75
        case .completed: return 1.0
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
        if let heading = heading {
            // GMSMarker rotation is clockwise from north
            // Truck image faces DOWN (south) at rotation 0, so subtract 180
            driverMarker?.rotation = heading - 180
        }

        CATransaction.commit()
    }

    // MARK: - Calculate Bearing
    func calculateBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let deltaLng = (to.longitude - from.longitude) * .pi / 180

        let x = sin(deltaLng) * cos(lat2)
        let y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng)

        var bearing = atan2(x, y) * 180 / .pi
        bearing = fmod(bearing + 360, 360)

        return bearing
    }
    
}
