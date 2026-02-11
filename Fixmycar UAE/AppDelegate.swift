//
//  AppDelegate.swift
//  Fixmycar UAE
//
//  Created by Ankit Gabani on 01/01/26.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey(google_place_key)
        GMSPlacesClient.provideAPIKey(google_place_key)

        if FCUtilites.getIsCurrentUser() {
            setUpHome()
        } else {
            setUpLogin()
        }
        
        return true
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

}

