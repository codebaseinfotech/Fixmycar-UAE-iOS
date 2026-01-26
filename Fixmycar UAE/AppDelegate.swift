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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey(google_place_key)
        GMSPlacesClient.provideAPIKey(google_place_key)

        let home = HomeVC()
        let homeNavigation = UINavigationController(rootViewController: home)
        homeNavigation.navigationBar.isHidden = true
        self.window?.rootViewController = homeNavigation
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

