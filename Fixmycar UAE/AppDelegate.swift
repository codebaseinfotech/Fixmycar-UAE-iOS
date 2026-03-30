//
//  AppDelegate.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 01/01/26.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseAnalytics
import OneSignal
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    static var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0
    
    var bannerPromoCode: String = ""
    
    var configVM = ConfigVM()
    var loginVM = VerifyOtpVM()
    var appDelegateVM = AppDelegateVM()
    var chatVM = ChatVM()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        getConfigData()
        callCheckApp()

        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        Analytics.setAnalyticsCollectionEnabled(true)
        
        GMSServices.provideAPIKey(google_place_key)
        GMSPlacesClient.provideAPIKey(google_place_key)
        
        // Notification delegate (IMPORTANT)
        UNUserNotificationCenter.current().delegate = self
//        setupNotificationCategories()
        requestNotificationPermission()
        setupOneSignal(launchOptions)
        
        if FCUtilites.getIsCurrentUser() {
            setUpHome()
        } else {
            setUpLogin()
        }
        
        return true
    }
    
    // MARK: - getConfigAPI()
    func getConfigData() {
        configVM.getGeneralSettings()
    }

    // MARK: - callCheckAppStatus
    func callCheckApp() {

        appDelegateVM.onSuccess = { [weak self] in
            guard let self = self else { return }
            guard let data = self.appDelegateVM.dicCheckAppData else { return }

            // Maintenance check
            if data.isMaintenance == true {
                DispatchQueue.main.async {
                    self.setUpMaintenance()
                }
                return
            }

            // Update available
            if data.updateAvailable == true {
                guard let topVC = UIApplication.shared.topMostViewController() else { return }

                // Prevent duplicate popup
                if topVC is NewVersionAvailablePopup { return }

                let vc = NewVersionAvailablePopup()
                vc.modalPresentationStyle = .overFullScreen
                vc.isForceUpdate = data.forceUpdate ?? false
                vc.onLater = {
                    FCUtilites.getIsCurrentUser() ? self.setUpHome() : self.setUpLogin()
                }
                vc.onUpdateNow = {
                    guard let url = URL(string: data.appLink ?? "") else { return }
                    UIApplication.shared.open(url)
                }
                topVC.present(vc, animated: false)
                return
            }

            debugPrint("App status OK")
        }

        appDelegateVM.onFailure = { error in
            debugPrint("Check app failed:", error)
        }

        appDelegateVM.checkAppStatusApi()
    }

    // MARK: - setUp Maintenance
    func setUpMaintenance() {
        let maintenance = AppMaintenanceVC()
        let nav = UINavigationController(rootViewController: maintenance)
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func callModifyLogin() {
        if FCUtilites.getIsCurrentUser() {
            loginVM.lastLoginModify(role: FCUtilites.getRoleName())
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        callModifyLogin()
        callCheckApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        callModifyLogin()
        callCheckApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        callModifyLogin()
        callCheckApp()
    }
    
    // MARK: - setUp Home
    func setUpHome() {
        setupGlobalSocketListener()
        connectSocketAndJoinAllRooms()
        let home = HomeVC()
        let homeNavigation = UINavigationController(rootViewController: home)
        homeNavigation.navigationBar.isHidden = true
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
    }

    // MARK: - Socket Setup
    func connectSocketAndJoinAllRooms() {
        FMSocketManager.shared.connect()
    }

    @objc private func handleSocketConnected() {
        debugPrint("[SOCKET-GLOBAL] Socket connected, joining all chat rooms...")
        joinAllChatRooms()
    }

    func joinAllChatRooms() {
        chatVM.successChatList = { [weak self] in
            guard let self = self else { return }

            debugPrint("[SOCKET-GLOBAL] Joining \(self.chatVM.chatList.count) chat rooms")

            for chat in self.chatVM.chatList {
                if let bookingId = chat.bookingId {
                    FMSocketManager.shared.joinRoom(bookingId: bookingId)
                    debugPrint("[SOCKET-GLOBAL] Joined room for booking: \(bookingId)")
                }
            }
        }
        
        if FCUtilites.getIsCurrentUser() {
            chatVM.getChatList()
        }
        
    }

    // MARK: - Global Socket Listener
    func setupGlobalSocketListener() {
        // Listen for socket connected
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSocketConnected),
            name: .socketConnected,
            object: nil
        )

        // Listen for socket messages
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSocketMessage(_:)),
            name: .socketMessageReceived,
            object: nil
        )
    }

    @objc private func handleSocketMessage(_ notification: Notification) {
        guard let message = notification.userInfo?["message"] as? MessageDetails else { return }

        debugPrint("[SOCKET-GLOBAL] New message received via notification")

        // Skip if it's our own message
        if message.is_me == true {
            debugPrint("[SOCKET-GLOBAL] Skipping own message echo")
            return
        }

        // Refresh chat list to update badge count
        DispatchQueue.main.async {
            self.refreshChatBadge()
        }
    }

    func refreshChatBadge() {
        if FCUtilites.getIsCurrentUser() {
            chatVM.getChatList()
        }
    }

    // MARK: - setUp Login
    func setUpLogin() {
        let login = LoginVC()
        let homeNavigation = UINavigationController(rootViewController: login)
        homeNavigation.navigationBar.isHidden = true
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - OneSignal Setup
    func setupOneSignal(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

        let receivedBlock: OSHandleNotificationReceivedBlock = { notification in
            guard let payload = notification?.payload else { return }
            debugPrint("📩 payload", payload ?? "")
            debugPrint("📩 Notification Received:", payload.notificationID ?? "")
            
            if payload.type == "completed" {
                if FCUtilites.getIsCurrentUser() {
                    NotificationCenter.default.post(
                        name: .refrechData,
                        object: nil,
                        userInfo: ["type": payload.type ?? ""]
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.presentAdminAssignPopup(payload: payload)
                    })
                }
            } else if payload.type == "job_accepted" ||
                        payload.type == "started" ||
                        payload.type == "on_the_way_to_pickup" ||
                        payload.type == "near_pickup" ||
                        payload.type == "arrived_at_pickup" ||
                        payload.type == "pickup_completed" ||
                        payload.type == "on_the_way_to_delivery" ||
                        payload.type == "near_delivery" ||
                        payload.type == "arrived_at_delivery" ||
                        payload.type == "trip_booked_by_admin" ||
                        payload.type == "trip_cancelled" ||
                        payload.type == "trip_cancelled_by_admin" ||
                        payload.type == "booking_accepted" {
                
                NotificationCenter.default.post(
                    name: .refrechData,
                    object: nil,
                    userInfo: ["type": payload.type ?? ""]
                )
                print("Driver going to pickup")
            }
        }
 
        let openedBlock: OSHandleNotificationActionBlock = { result in
//            guard let actionId = result?.action.actionID else { return }
            guard let payload = result?.notification.payload else { return }

            debugPrint("📨 Notification Opened")
            debugPrint("Sound:", payload.sound ?? "default")

            if payload.type == "completed" {
                if FCUtilites.getIsCurrentUser() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.presentAdminAssignPopup(payload: payload)
                    })
                }
            }
//            switch actionId {
//                case "accept":
//                    debugPrint("✅ ACCEPT tapped")
//                    // call accept booking API
//
//                case "reject":
//                    debugPrint("❌ REJECT tapped")
//                    // call reject booking API
//
//                case "__DEFAULT__":
//                    debugPrint("Notification tapped normally")
//
//                default:
//                    break
//                }

            if let data = payload.additionalData,
               let type = data["type"] as? String {
                

                NotificationCenter.default.post(
                    name: Notification.Name("ONESIGNAL_EVENT"),
                    object: nil,
                    userInfo: data
                )

                debugPrint("➡️ Notification Type:", type)
            }
        }

        let settings: [String: Any] = [
            kOSSettingsKeyAutoPrompt: true,
            kOSSettingsKeyInAppLaunchURL: false
        ]

        OneSignal.initWithLaunchOptions(
            launchOptions,
            appId: ONE_SINGNAL_ID,
            handleNotificationReceived: receivedBlock,
            handleNotificationAction: openedBlock,
            settings: settings
        )

        OneSignal.inFocusDisplayType = .notification

        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    // MARK: - Present
    func presentAdminAssignPopup(payload: OSNotificationPayload) {
        guard let topVC = UIApplication.shared.topMostViewController() else {
            return
        }

        let vc = AddRateVC()
        vc.modalPresentationStyle = .pageSheet

        if let sheet = vc.sheetPresentationController {
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { _ in
                return 300
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true
        }

        vc.sheetPresentationController?.delegate = self
        vc.addRateVM.notificationPayload = payload

        vc.tappedSubmit = { [weak self] in
            
            let successVC = BookingSuccessPopUpVC()
            successVC.modalPresentationStyle = .pageSheet
            
            if let sheet = successVC.sheetPresentationController {
                let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed250")) { _ in
                    return 280
                }
                sheet.detents = [fixedDetent]
                sheet.prefersGrabberVisible = true
            }
            
            successVC.sheetPresentationController?.delegate = self
            successVC.strOpenFrom = "rate_driver"
            topVC.present(successVC, animated: true)
        }

        topVC.present(vc, animated: true)
    }

    // MARK: - Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            debugPrint("Notification Permission:", granted)
        }
    }

    // MARK: - Notification Foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: [.alert, .sound, .badge, .criticalAlert]
//        ) { granted, error in
//            debugPrint("Critical Alert Permission:", granted)
//        }
        
        completionHandler([.banner, .sound, .badge])
    }
}

// MARK: - OneSignal Delegates
extension AppDelegate: OSPermissionObserver, OSSubscriptionObserver {

    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        debugPrint("🔔 Permission:", stateChanges?.to.status ?? false)
    }

    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if let userId = stateChanges.to.userId {
            debugPrint("✅ OneSignal Player ID:", userId)
            FCUtilites.saveOneSignleToken(userId)
        }
    }
}

// MARK: - OSNotificationPayload
extension OSNotificationPayload {
    var bookingId: Int? {
        guard let rawPayload = rawPayload,
              let custom = rawPayload["custom"] as? [String: Any],
              let a = custom["a"] as? [String: Any] else {
            return nil
        }

        if let id = a["booking_id"] as? Int {
            return id
        }

        if let idStr = a["booking_id"] as? String {
            return Int(idStr)
        }

        return nil
    }
    
    var type: String? {
        guard let rawPayload = rawPayload,
              let custom = rawPayload["custom"] as? [String: Any],
              let a = custom["a"] as? [String: Any] else {
            return nil
        }

        if let id = a["type"] as? String {
            return id
        }

        if let idStr = a["type"] as? String {
            return idStr
        }

        return nil
    }
}

// MARK: - topMostViewController
extension UIApplication {
    func topMostViewController(
        base: UIViewController? = UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            return topMostViewController(base: tab.selectedViewController)
        }

        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }

        return base
    }
}


// MARK: - PresentSheet
extension AppDelegate: UISheetPresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {

        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.windows.first }).first,
              let rootView = window.rootViewController?.view else { return }

        if let overlayView = rootView.viewWithTag(999) {

            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
    }
}

