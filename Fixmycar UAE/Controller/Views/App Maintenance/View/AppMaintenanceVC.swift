//
//  AppMaintenanceVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/03/26.
//

import UIKit

class AppMaintenanceVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedGetHelp(_ sender: Any) {
        // Open support URL or show alert
        if let url = URL(string: "https://torettorecovery.ae/contact") {
            UIApplication.shared.open(url)
        }
    }

}
