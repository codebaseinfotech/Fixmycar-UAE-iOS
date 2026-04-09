//
//  BookingFareAmountVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 26/01/26.
//

import UIKit
import GoogleMaps

class BookingFareAmountVC: UIViewController, UISheetPresentationControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblEstimatedTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtPickup: UITextField!
    @IBOutlet weak var txtDrop: UITextField!
    
    var viewModel = BookingFareAmountVM()
    var googleMapVM = GoogleDistanceVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPickup.text = CreateBooking.shared.pickup_address
        txtDrop.text = CreateBooking.shared.dropoff_address
         
        setupMap()
        addMarkers()
        
        debugPrint("pickup_lat", CreateBooking.shared.pickup_lat ?? 0.0)
        debugPrint("pickup_lng", CreateBooking.shared.pickup_lng ?? 0.0)
        debugPrint("dropoff_lat", CreateBooking.shared.dropoff_lat ?? 0.0)
        debugPrint("dropoff_lng", CreateBooking.shared.dropoff_lng ?? 0.0)

        calculateDistance()
        
        viewModel.successCalculatePrice = {
//            let rounded = Double(String(format: "%.3f", self.viewModel.priceData?.distanceKm ?? 0.0))!
//            self.lblDistance.text = "Distance:" + " \(rounded) km"
            
            self.lblPrice.text = "\(self.viewModel.priceData?.currency ?? "") \(self.viewModel.priceData?.price ?? 0.0)"

            CreateBooking.shared.price = self.viewModel.priceData?.price ?? 0.0
            CreateBooking.shared.currency = self.viewModel.priceData?.currency ?? ""
            
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
        
        googleMapVM.getDistance(originLat: CreateBooking.shared.pickup_lat ?? 0.0, originLng: CreateBooking.shared.pickup_lng ?? 0.0, destLat: CreateBooking.shared.dropoff_lat ?? 0.0, destLng: CreateBooking.shared.dropoff_lng ?? 0.0)
            
        googleMapVM.successGoogleDistance = {
            self.lblDistance.text = "Distance: " + "\(self.googleMapVM.distanceWithName)"
            self.lblEstimatedTime.text = "Estimated time taken: " + "\(self.googleMapVM.durationWithName)"
            
            self.drawRoute(resultPolyline: self.googleMapVM.resultPolyline)
            
            CreateBooking.shared.distance_km = self.googleMapVM.distance
            
            let duration = self.googleMapVM.durationWithName.toMinutes()
            CreateBooking.shared.eta_minutes = "\(duration)"
            
            self.viewModel.getCalculatePrice(km: self.googleMapVM.distance, minutes: duration)
        }
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
        // Check if drivers are available
       // if viewModel.availableDrivers.isEmpty {
            showNoDriversPopup()
//        } else {
//            proceedToFareBreakup()
//        }
    }

    // MARK: - Show No Drivers Popup
    private func showNoDriversPopup() {
        let popup = NoDriversAvailablePopup()
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve

        popup.onContinueBooking = { [weak self] in
            self?.proceedToFareBreakup()
        }

        popup.onContactSupport = { [weak self] in
            self?.contactSupport()
        }

        popup.onCancel = { [weak self] in
            // Navigate to home page
            self?.navigationController?.popToRootViewController(animated: true)
        }

        present(popup, animated: true)
    }

    // MARK: - Proceed to Fare Breakup
    private func proceedToFareBreakup() {
        let vc = FareBreakupVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Contact Support
    private func contactSupport() {
        let vc = JumpStartVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 220
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        vc.isHomeOpen = false
        self.present(vc, animated: true)
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
    
    /*func showPolyline(encodedPath: String) {

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
    }*/





}

// MARK: - No Drivers Available Popup
class NoDriversAvailablePopup: UIViewController {

    // MARK: - Callbacks
    var onContinueBooking: (() -> Void)?
    var onContactSupport: (() -> Void)?
    var onCancel: (() -> Void)?

    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️ Sorry! No Drivers Available"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "We don’t have any drivers available in your area for the next 30 minutes.\n\nIf your trip isn’t urgent, you can continue booking.\nFor immediate assistance, please contact support."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue Booking", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primeryBlack
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueBookingTapped), for: .touchUpInside)
        return button
    }()

    private lazy var contactSupportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Contact Support", for: .normal)
        button.setTitleColor(.primeryBlack, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primeryBlack.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(contactSupportTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(continueButton)
        containerView.addSubview(contactSupportButton)
        containerView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            // Container
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Message
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Continue Button
            continueButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 48),

            // Contact Support Button
            contactSupportButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 12),
            contactSupportButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contactSupportButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contactSupportButton.heightAnchor.constraint(equalToConstant: 48),

            // Cancel Button
            cancelButton.topAnchor.constraint(equalTo: contactSupportButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    @objc private func continueBookingTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onContinueBooking?()
        }
    }

    @objc private func contactSupportTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onContactSupport?()
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCancel?()
        }
    }
}

