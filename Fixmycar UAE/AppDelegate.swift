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
    
    var configVM = ConfigVM()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        getConfigData()
        
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
    
    // MARK: - setUp Home
    func setUpHome() {
        let home = HomeVC()
        let homeNavigation = UINavigationController(rootViewController: home)
        homeNavigation.navigationBar.isHidden = true
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
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
        }
 
        let openedBlock: OSHandleNotificationActionBlock = { result in
//            guard let actionId = result?.action.actionID else { return }
            guard let payload = result?.notification.payload else { return }

            debugPrint("📨 Notification Opened")
            debugPrint("Sound:", payload.sound ?? "default")

           
//            switch actionId {
//                case "accept":
//                    print("✅ ACCEPT tapped")
//                    // call accept booking API
//
//                case "reject":
//                    print("❌ REJECT tapped")
//                    // call reject booking API
//
//                case "__DEFAULT__":
//                    print("Notification tapped normally")
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

    // MARK: - Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            print("Notification Permission:", granted)
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
//            print("Critical Alert Permission:", granted)
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
