//
//  HomeVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
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
    
    // MARK: - Chat Badge Outlet (Connect this outlet to your Chat tab view in Interface Builder)
    @IBOutlet weak var viewTChatMain: UIView!
    
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
    @IBOutlet weak var collectionViewBanner: UICollectionView! {
        didSet {
            collectionViewBanner.register(HomeBannerCVCell.nib, forCellWithReuseIdentifier: HomeBannerCVCell.identifier)
            collectionViewBanner.delegate = self
            collectionViewBanner.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewServices: UICollectionView! {
        didSet {
            collectionViewServices.register(HomeServicesCVCell.nib, forCellWithReuseIdentifier: HomeServicesCVCell.identifier)
            collectionViewServices.delegate = self
            collectionViewServices.dataSource = self
        }
    }
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    var homeVM = HomeVM()
    var chatVM = ChatVM()
    private var lblChatBadge: UILabel?
    let refreshControl = UIRefreshControl()

    // MARK: - Banner Page Control & Auto Scroll
    @IBOutlet weak var bannerPageControl: UIPageControl!
    private var bannerAutoScrollTimer: Timer?
    private var currentBannerIndex: Int = 0
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = "Hello, " + (FCUtilites.getCurrentUser()?.name ?? "")

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        scrollView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshPageData(_:)),
            name: .createNewBooking,
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBooking(_notification:)), name: NSNotification.Name.refrechData, object: nil)
        

        // Chat badge observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateChatBadge(_:)),
            name: .chatUnreadCountUpdated,
            object: nil
        )
        setupChatBadge()
        chatVM.getChatList()

        // Setup banner page control
        setupBannerPageControl()

        // Do any additional setup after loading the view.
    }

    // MARK: - Setup Banner Page Control
    private func setupBannerPageControl() {
        bannerPageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        collectionViewBanner.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentBannerIndex = page
    }

    // MARK: - Banner Auto Scroll
    private func startBannerAutoScroll() {
        stopBannerAutoScroll()
        guard homeVM.homeBanner.count > 1 else { return }

        bannerAutoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }

    private func stopBannerAutoScroll() {
        bannerAutoScrollTimer?.invalidate()
        bannerAutoScrollTimer = nil
    }

    private func scrollToNextBanner() {
        guard homeVM.homeBanner.count > 0 else { return }

        currentBannerIndex += 1
        if currentBannerIndex >= homeVM.homeBanner.count {
            currentBannerIndex = 0
        }

        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        collectionViewBanner.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bannerPageControl.currentPage = currentBannerIndex
    }

    private func updateBannerPageControl() {
        bannerPageControl.numberOfPages = homeVM.homeBanner.count
        bannerPageControl.currentPage = currentBannerIndex
        bannerPageControl.isHidden = homeVM.homeBanner.count <= 1
        startBannerAutoScroll()
    }
    
    // MARK: - pull to refresh API
    @objc func refreshData() {
        print("Refreshing...")
        
        // Call API or reload data here
        homeVM.getHomeData()
    }
    
    // MARK: - refreshBooking
    @objc func refreshBooking(_notification: NSNotification){
        homeVM.getHomeData()
    }

    // MARK: - Chat Badge
    private func setupChatBadge() {
        // Try outlet first, otherwise find chat button programmatically
        var chatView: UIView? = viewTChatMain

        if chatView == nil {
            // Find the chat button by searching for button with tappedTChat action
            chatView = findChatButtonParentView()
        }

        guard let targetView = chatView else { return }

        let badge = UILabel()
        badge.backgroundColor = UIColor(named: "primary_red") ?? .red
        badge.textColor = .white
        badge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 9
        badge.layer.masksToBounds = true
        badge.isHidden = true
        badge.translatesAutoresizingMaskIntoConstraints = false

        targetView.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.topAnchor.constraint(equalTo: targetView.topAnchor, constant: 8),
            badge.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -15),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            badge.heightAnchor.constraint(equalToConstant: 18)
        ])
        lblChatBadge = badge
    }

    private func findChatButtonParentView() -> UIView? {
        return findButtonParentView(in: view, action: #selector(tappedTChat(_:)))
    }

    private func findButtonParentView(in view: UIView, action: Selector) -> UIView? {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                if let actions = button.actions(forTarget: self, forControlEvent: .touchUpInside) {
                    if actions.contains(NSStringFromSelector(action)) {
                        return button.superview
                    }
                }
            }
            if let found = findButtonParentView(in: subview, action: action) {
                return found
            }
        }
        return nil
    }

    @objc private func updateChatBadge(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        DispatchQueue.main.async {
            if count > 0 {
                self.lblChatBadge?.text = count > 99 ? "99+" : "\(count)"
                self.lblChatBadge?.isHidden = false
            } else {
                self.lblChatBadge?.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocation()
        homeVM.getHomeData()
        viewActiveBooking.config(type: "active_job")
        homeVM.successHomeData = { [weak self] in
            self?.svNoBookingFound.isHidden = self?.homeVM.homeData?.activeBooking?.count == 0 ? false : true
            self?.tblViewRecentBooking.isHidden = self?.homeVM.recentServiceList.count == 0 ? true : true

            self?.tblViewRecentBooking.reloadData()
            self?.collectionViewBanner.reloadData()
            self?.collectionViewServices.reloadData()
            self?.updateBannerPageControl()

            self?.viewMainActiveBooking.isHidden = self?.homeVM.homeData?.activeBooking?.count == 0 ? true : false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.refreshControl.endRefreshing()
            }

            guard let homeData = self?.homeVM.homeData else {
                debugPrint("❌ homeData is nil")
                return
            }

            guard let activeBooking = homeData.activeBooking, !activeBooking.isEmpty else {
                debugPrint("❌ activeBooking empty or nil")
                return
            }
            
            self?.viewActiveBooking.lblType.text = activeBooking[0].serviceName
            self?.viewActiveBooking.lblTime.text = activeBooking[0].jobDate?.toDisplayDate()
            self?.viewActiveBooking.lblPickLocation.text = activeBooking[0].pickupAddress
            self?.viewActiveBooking.lblDropLocation.text = activeBooking[0].dropAddress
            self?.viewActiveBooking.lblPrice.text = (activeBooking[0].currency ?? "") + " " + "\(activeBooking[0].amount ?? 0.0)"
            self?.viewActiveBooking.lblStatus.text = "View"
            self?.viewActiveBooking.lblStatus.textColor = .white
            self?.viewActiveBooking.viewStatus.backgroundColor = .primeryBlack
            self?.viewActiveBooking.viewStatus.borderColor = .clear
            
            let jobStatus: JobStatus = JobStatus(rawValue: activeBooking[0].status ?? "") ?? .accepted
            switch jobStatus {
            case .pending:
                self?.lblActiveStatus.text = "Pending"
                
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
            self?.refreshControl.endRefreshing()
            self?.setUpMakeToast(msg: msg)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBannerAutoScroll()
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()   // 🔴 Start Live Location
    }
    
    @objc func refreshPageData(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = ThankYouPopUp(nibName: "ThankYouPopUp", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }

    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newsize = change?[.newKey] as? CGSize {
                self.heightTVRecentBooking.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    /*@IBAction func tappedRecovery(_ sender: Any) {
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
    }*/
    @IBAction func tappedViewAllRecentBooking(_ sender: Any) {
        tappedTHistory(self)
    }
    
    @IBAction func tappedNotification(_ sender: Any) {
        let vc = NotificationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedActiveJob(_ sender: Any) {
        guard let active = homeVM.homeData?.activeBooking?.first,
              let bookingId = active.id else { return }
        
        let status = active.status?.lowercased() ?? ""
        
        if status == "pending" {
            let vc = PendingJobVC()
            vc.activeBookingId = bookingId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = TrackLiveVC()
            vc.trackLiveVM.bookingId = bookingId
            navigationController?.pushViewController(vc, animated: true)
        }
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

// MARK: - collectionView Delegate & DataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewBanner:
            return homeVM.homeBanner.count
        case collectionViewServices:
            return homeVM.homeServices.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewBanner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCVCell", for: indexPath) as! HomeBannerCVCell
            
            let dicData = homeVM.homeBanner[indexPath.item]

            cell.imgPic.loadFromUrlString(dicData.imageURL ?? "", placeholder: "ic_dummy_banner".image)

            return cell
            
        case collectionViewServices:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeServicesCVCell", for: indexPath) as! HomeServicesCVCell
            
            let dicData = homeVM.homeServices[indexPath.item]
            
            cell.lblName.text = dicData.name ?? ""
            
            cell.imgPic.image = indexPath.item == 0 ? "ic_recovery".image : "ic_jump_start".image
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewBanner:
            let dicData = homeVM.homeBanner[indexPath.item]
            
            if dicData.buttonText == "Book Now" {
                AppDelegate.appDelegate.bannerPromoCode = dicData.promoCode ?? ""
                
                let vc = RecoveryServiceVC()
                navigationController?.pushViewController(vc, animated: true)
                
            } else {
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
            
        case collectionViewServices:
            let dicData = homeVM.homeServices[indexPath.item]
            
            let name = dicData.name?.replacingOccurrences(of: " Service", with: "")
            
            if name == "Recovery" {
                let vc = RecoveryServiceVC()
                navigationController?.pushViewController(vc, animated: true)
            } else {
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
            
        default:
            break
        }
    }

    // MARK: - ScrollView Delegate for Banner
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            let pageWidth = scrollView.frame.width
            let page = Int(scrollView.contentOffset.x / pageWidth)
            currentBannerIndex = page
            bannerPageControl.currentPage = page
            startBannerAutoScroll()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner {
            stopBannerAutoScroll()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionViewBanner && !decelerate {
            startBannerAutoScroll()
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    // MARK:- Section Insets
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    // MARK:- Minimum Line Spacing (Vertical)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionViewServices:
            return 15
        default:
            return .zero
        }
    }
    
    // MARK:- Minimum Interitem Spacing (Horizontal)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionViewServices:
            return 15
        default:
            return .zero
        }
    }
    
    // MARK:- sizeForItemAt
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case collectionViewBanner:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case collectionViewServices:
            
            let width = (collectionView.frame.width-15) / 2
            return CGSize(width: width, height: collectionView.frame.height)
            
        default:
            return .zero
        }
        
    }
    
    
    
}

// MARK: - tv Delegate & DataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeVM.recentServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as? RecentBookingTVCell else {
            return UITableViewCell()
        }
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
                debugPrint("Geocode error:", error.localizedDescription)
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
        debugPrint("Location error:", error.localizedDescription)
    }
}
