//
//  HomeVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewDotsNotification: UIView!
    
    @IBOutlet weak var tblViewRecentBooking: UITableView! {
        didSet {
            tblViewRecentBooking.register(RecentBookingTVCell.nib, forCellReuseIdentifier: RecentBookingTVCell.identifier)
            tblViewRecentBooking.delegate = self
            tblViewRecentBooking.dataSource = self
            
            tblViewRecentBooking.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            tblViewRecentBooking.separatorStyle = .none
        }
    }
    @IBOutlet weak var heightTVRecentBooking: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var homeVM = HomeVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = "Hello, " + (FCUtilites.getCurrentUser()?.name ?? "") + "👋"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocation()
               
        homeVM.successHomeData = { [weak self] in
            self?.tblViewRecentBooking.reloadData()
        }
        homeVM.failureHomeData = { [weak self] msg in
            self?.setUpMakeToast(msg: msg)
        }
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()   // 🔴 Start Live Location
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                self.heightTVRecentBooking.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedApplyCode(_ sender: Any) {
    }
    @IBAction func tappedRecovery(_ sender: Any) {
        let vc = RecoveryServiceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedJumpStart(_ sender: Any) {
        let vc = JumpStartVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 300
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func tappedViewAllRecentBooking(_ sender: Any) {
    }
    
    @IBAction func tappedNotification(_ sender: Any) {
        let vc = NotificationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - tabbar Action
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTTrackLive(_ sender: Any) {
        let vc = TrackLiveVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTChat(_ sender: Any) {
        let vc = ChatVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTSetting(_ sender: Any) {
        let vc = SettingVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

// MARK: - tv Delegate & DataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeVM.recentServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as! RecentBookingTVCell
        cell.selectionStyle = .none
        cell.viewRecentBooking.config(type: "recent_booking")

        let dicData = homeVM.recentServiceList[indexPath.row]
        cell.recentBooking = dicData
        
        return cell
    }
    
    
}

// MARK: - PresentSheet
extension HomeVC: UISheetPresentationControllerDelegate {
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

// MARK: - location Delegate
extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        AppDelegate.appDelegate.currentLatitude = latitude
        AppDelegate.appDelegate.currentLongitude = longitude
        debugPrint("Live Latitude:", latitude)
        debugPrint("Live Longitude:", longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let error = error {
                print("Geocode error:", error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            let area = placemark.subLocality        // Area
            let city = placemark.locality           // City
            /*let state = placemark.administrativeArea
            let country = placemark.country
            let postalCode = placemark.postalCode*/
            
            debugPrint("Area:", area ?? "")
            debugPrint("City:", city ?? "")
            /*debugPrint("State:", state ?? "")
            debugPrint("Country:", country ?? "")
            debugPrint("Pincode:", postalCode ?? "")*/
            
            self.lblLocation.text = "\(area ?? ""), \(city ?? "")"
        }
        locationManager.stopUpdatingLocation()
        homeVM.getHomeData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
}
