//
//  HomeVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit
import CoreLocation

enum JobStatus: String {
    case pending = "pending"
    case accepted = "accepted"
    case started = "started"
    case onTheWayToPickup = "on_the_way_to_pickup"
    case nearPickup = "near_pickup"
    case arrivedAtPickup = "arrived_at_pickup"
    case pickupCompleted = "pickup_completed"

    case onTheWayToDelivery = "on_the_way_to_delivery"
    case nearDelivery = "near_delivery"
    case arrivedAtDelivery = "arrived_at_delivery"
    case completed = "completed"
    case cancelled = "cancelled"
}

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
    @IBOutlet weak var svNoBookingFound: UIStackView!
    @IBOutlet weak var viewMainActiveBooking: UIView!
    @IBOutlet weak var viewActiveBooking: RecentBookingsView!
    @IBOutlet weak var viewActiveStatus: UIView!
    @IBOutlet weak var lblActiveStatus: AppLabel!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var homeVM = HomeVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = "Hello, " + (FCUtilites.getCurrentUser()?.name ?? "")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocation()
        viewActiveBooking.config(type: "active_job")
        homeVM.successHomeData = { [weak self] in
            self?.svNoBookingFound.isHidden = self?.homeVM.recentServiceList.count == 0 ? false : true
            self?.tblViewRecentBooking.isHidden = self?.homeVM.recentServiceList.count == 0 ? true : false
            
            self?.tblViewRecentBooking.reloadData()
            
            self?.viewMainActiveBooking.isHidden = self?.homeVM.homeData?.activeBooking?.count == 0 ? true : false
            
            guard let homeData = self?.homeVM.homeData else {
                print("❌ homeData is nil")
                return
            }

            guard let activeBooking = homeData.activeBooking, !activeBooking.isEmpty else {
                print("❌ activeBooking empty or nil")
                return
            }
            
            self?.viewActiveBooking.lblType.text = activeBooking[0].serviceName
            self?.viewActiveBooking.lblTime.text = activeBooking[0].jobDate?.toDisplayDate()
            self?.viewActiveBooking.lblPickLocation.text = activeBooking[0].pickupAddress
            self?.viewActiveBooking.lblDropLocation.text = activeBooking[0].dropAddress
            self?.viewActiveBooking.lblPrice.text = (activeBooking[0].currency ?? "") + " " + (activeBooking[0].amount ?? "")
            self?.viewActiveBooking.lblStatus.text = "View"
            self?.viewActiveBooking.lblStatus.textColor = .white
            self?.viewActiveBooking.viewStatus.backgroundColor = .primeryBlack
            self?.viewActiveBooking.viewStatus.borderColor = .clear
            
            let jobStatus: JobStatus = JobStatus(rawValue: activeBooking[0].status ?? "") ?? .accepted
            switch jobStatus {
            case .pending:
                self?.lblActiveStatus.text = "pending"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.pending_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.pending_border
                self?.lblActiveStatus.textColor = UIColor.AppColor.pending_border
                
            case .accepted:
                self?.lblActiveStatus.text = "Accepted"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.started_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.started_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.started_border
            case .started:
                self?.lblActiveStatus.text = "Started"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.started_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.started_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.started_border
            case .onTheWayToPickup:
                self?.lblActiveStatus.text = "On the way to pickup"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.one_way_to_pickup_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.one_way_to_pickup_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.one_way_to_pickup_border
            case .nearPickup:
                self?.lblActiveStatus.text = "Near pickup"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.near_pickup_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.near_pickup_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.near_pickup_border
            case .arrivedAtPickup:
                self?.lblActiveStatus.text = "Arrived at pickup"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.arrived_pick_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.arrived_pick_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.arrived_pick_border
            case .pickupCompleted:
                self?.lblActiveStatus.text = "Pickup completed"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.pickup_completed_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.pickup_completed_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.pickup_completed_border
            case .onTheWayToDelivery:
                self?.lblActiveStatus.text = "On the way to delivery"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.one_way_to_delivery_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.one_way_to_delivery_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.one_way_to_delivery_border
            case .nearDelivery:
                self?.lblActiveStatus.text = "Near delivery"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.near_delivery_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.near_delivery_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.near_delivery_border
            case .arrivedAtDelivery:
                self?.lblActiveStatus.text = "Arrived at delivery"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.arrived_delivery_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.arrived_delivery_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.arrived_delivery_border
            case .completed:
                self?.lblActiveStatus.text = "Completed"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.completrd_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.completrd_border
                
                self?.lblActiveStatus.textColor = UIColor.AppColor.completrd_border
            case .cancelled:
                self?.lblActiveStatus.text = "Cancelled"
                
                self?.viewActiveStatus.backgroundColor = UIColor.AppColor.cancelled_bg
                self?.viewActiveStatus.borderColor = UIColor.AppColor.cancelled_border
            
                self?.lblActiveStatus.textColor = UIColor.AppColor.cancelled_bg
            }
            
        }
        homeVM.failureHomeData = { [weak self] msg in
            self?.svNoBookingFound.isHidden = self?.homeVM.recentServiceList.count == 0 ? false : true
            self?.tblViewRecentBooking.isHidden = self?.homeVM.recentServiceList.count == 0 ? true : false
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
        tappedTHistory(self)
    }
    
    @IBAction func tappedNotification(_ sender: Any) {
        let vc = NotificationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedActiveJob(_ sender: Any) {
        let vc = TrackLiveVC()
        vc.trackLiveVM.bookingId = self.homeVM.homeData?.activeBooking?[0].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - tabbar Action
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTChat(_ sender: Any) {
        let vc = ChatVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTSettings(_ sender: Any) {
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: false)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = homeVM.recentServiceList[indexPath.row]

        let vc = BookingDetailsVC()
        vc.bookingVM.bookingid = dicData.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
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
