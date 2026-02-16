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
    
    private var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        // Do any additional setup after loading the view.
    }
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Default location (Dubai)
        let camera = GMSCameraPosition.camera(
            withLatitude: 25.2048,
            longitude: 55.2708,
            zoom: 14
        )
        
        mapView = GMSMapView(frame: viewMap.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        
        viewMap.addSubview(mapView)
    }

    //MARK: - Tabbar Action
    @IBAction func tappedHome(_ sender: Any) {
        let vc = HomeVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func tappedHistory(_ sender: Any) {
        let vc = HistoryVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func tappedChat(_ sender: Any) {
        let vc = ChatVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func tappedSetting(_ sender: Any) {
        let vc = SettingVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - Action Method
    @IBAction func tappedChatWithDriver(_ sender: Any) {
    }
    
    @IBAction func tappedCall(_ sender: Any) {
    }
    
    
}

extension TrackLiveVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 16
        )

        mapView.animate(to: camera)

        // Stop to save battery
        locationManager.stopUpdatingLocation()
    }
}
