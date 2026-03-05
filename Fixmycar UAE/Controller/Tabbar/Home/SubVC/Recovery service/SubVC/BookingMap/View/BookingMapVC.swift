//
//  BookingMapVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 26/01/26.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol onTappedConfirmLocation: AnyObject {
    func tappedConfirmLocation(isDropLocation: Bool, location: String, lat: Double, lang: Double)
}

class BookingMapVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.text = isDropAddress ? "Destination location".localized : "Pickup location".localized
        }
    }
    @IBOutlet weak var txtLocation: UITextField! {
        didSet {
            txtLocation.placeholder = isDropAddress ? "Enter destination location" : "Enter pickup location"
        }
    }
    @IBOutlet weak var btnClose: UIButton! {
        didSet {
            btnClose.isHidden = true
        }
    }
    @IBOutlet weak var tblViewAddressList: UITableView! {
        didSet {
            tblViewAddressList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

            tblViewAddressList.register(PopularLocationTVCell.nib, forCellReuseIdentifier: PopularLocationTVCell.identifier)
            tblViewAddressList.delegate = self
            tblViewAddressList.dataSource = self
        }
    }
    @IBOutlet weak var btnConfirmLocation: UIButton! {
        didSet {
            let btnTitle = isDropAddress ? "Confirm Drop-off Location" : "Confirm Pickup Location"
            btnConfirmLocation.setTitle(btnTitle.localized, for: [])
        }
    }
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewMainPopular: UIView! {
        didSet {
            viewMainPopular.isHidden = true
        }
    }
    @IBOutlet weak var viewLocationList: UIView! {
        didSet {
            viewLocationList.isHidden = true
        }
    }
    @IBOutlet weak var heightTV: NSLayoutConstraint!
    
    private let locationManager = CLLocationManager()
    private let placesClient = GMSPlacesClient.shared()

    private var predictions: [GMSAutocompletePrediction] = []
    private var selectedCoordinate: CLLocationCoordinate2D?
    private var sessionToken: GMSAutocompleteSessionToken?
    
    var isDropAddress: Bool = false
    var delegateLocation: onTappedConfirmLocation?
    private var locationMarker: GMSMarker?

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupSearchField()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                self.heightTV.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedClose(_ sender: Any) {
        txtLocation.text = ""
        predictions.removeAll()
        tblViewAddressList.reloadData()
        viewMainPopular.isHidden = true
        viewLocationList.isHidden = true
        btnClose.isHidden = true
        sessionToken = nil
    }
    @IBAction func tappedConfirm(_ sender: Any) {
        guard let coordinate = selectedCoordinate else { return }
        debugPrint("Confirmed Lat:", coordinate.latitude)
        debugPrint("Confirmed Lng:", coordinate.longitude)
        
        delegateLocation?.tappedConfirmLocation(isDropLocation: isDropAddress, location: txtLocation.text ?? "", lat: coordinate.latitude, lang: coordinate.longitude)
        tappedBack(self)
    }
    @IBAction func tappedCurrentLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
     

}

// MARK: - TV Delegate & DataSource
extension BookingMapVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return predictions.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: PopularLocationTVCell.identifier,
            for: indexPath
        ) as! PopularLocationTVCell

        let item = predictions[indexPath.row]

        // ✅ Full address
        cell.lblNam.text = item.attributedFullText.string
        cell.lblAddress.text = ""

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let prediction = predictions[indexPath.row]

        placesClient.fetchPlace(
            fromPlaceID: prediction.placeID,
            placeFields: [.coordinate, .formattedAddress],
            sessionToken: sessionToken
        ) { place, error in

            guard let place = place else { return }

            self.selectedCoordinate = place.coordinate
            self.txtLocation.text = prediction.attributedFullText.string
            self.btnClose.isHidden = false
            self.sessionToken = nil

            // Update Map
            self.mapView.clear()

            let marker = GMSMarker(position: place.coordinate)
            marker.map = self.mapView

            self.showMarker(at: place.coordinate)

            let camera = GMSCameraPosition.camera(
                withLatitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude,
                zoom: 16
            )

            self.mapView.animate(to: camera)
            self.view.endEditing(true)
            self.viewLocationList.isHidden = true
            
//            self.viewMainPopular.isHidden = true
        }
    }
}


// MARK: - Map Setup
extension BookingMapVC: CLLocationManagerDelegate {

    func setupMap() {

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

//        mapView.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }

        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 15
        )

        mapView.animate(to: camera)

        // ✅ Show custom marker on first load
        showMarker(at: location.coordinate)

        // ✅ Store current coordinate
        selectedCoordinate = location.coordinate

        // ✅ Get address name from coordinates (Reverse Geocoding)
        
        if isDropAddress == false {
            getAddressFromCoordinate(location.coordinate)
        }

        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Custom Marker
extension BookingMapVC {

    func showMarker(at coordinate: CLLocationCoordinate2D) {

        mapView.clear()

        locationMarker = GMSMarker(position: coordinate)

        if let image = UIImage(named: "live_location_icon") {

            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
            imageView.contentMode = .scaleAspectFit

            locationMarker?.iconView = imageView
            locationMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }

        locationMarker?.map = mapView
    }
}


// MARK: - Reverse Geocoding
extension BookingMapVC {

    func getAddressFromCoordinate(_ coordinate: CLLocationCoordinate2D) {

        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in

            guard let self = self else { return }

            if let error = error {
                debugPrint("Reverse geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {

                // Full address banavo
                var addressParts: [String] = []

                if let name = placemark.name {
                    addressParts.append(name)
                }
                if let locality = placemark.locality {
                    addressParts.append(locality)
                }
                if let administrativeArea = placemark.administrativeArea {
                    addressParts.append(administrativeArea)
                }
                if let country = placemark.country {
                    addressParts.append(country)
                }

                let fullAddress = addressParts.joined(separator: ", ")

                DispatchQueue.main.async {
                    self.txtLocation.text = fullAddress
                    self.viewMainPopular.isHidden = false
                    self.btnClose.isHidden = false
                }
            }
        }
    }
}


// MARK: - textField Delegate
extension BookingMapVC: UITextFieldDelegate {

    func setupSearchField() {
        txtLocation.addTarget(self,
                              action: #selector(textDidChange),
                              for: .editingChanged)
    }

    @objc func textDidChange() {

        guard let text = txtLocation.text,
              !text.isEmpty else {

            predictions.removeAll()
            tblViewAddressList.reloadData()
            viewMainPopular.isHidden = true
            viewLocationList.isHidden = true
            sessionToken = nil
            return
        }

        if sessionToken == nil {
            sessionToken = GMSAutocompleteSessionToken()
        }

        let filter = GMSAutocompleteFilter()

        filter.countries = ["AE"]   // ✅ UAE restriction IN
        filter.type = .noFilter     // better suggestions

        placesClient.findAutocompletePredictions(
            fromQuery: text,
            filter: filter,
            sessionToken: sessionToken
        ) { results, error in

            guard let results = results else { return }

            self.predictions = results
            self.viewMainPopular.isHidden = false
            self.viewLocationList.isHidden = false
            self.tblViewAddressList.reloadData()
        }
    }
}


