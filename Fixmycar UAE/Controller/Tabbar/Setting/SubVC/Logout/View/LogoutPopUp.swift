//
//  LogoutPopUp.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class LogoutPopUp: UIViewController {

    @IBOutlet weak var imgLogout: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet weak var btnLogout: AppButton!
    
    var isOpenLogout: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isOpenLogout {
            imgLogout.image = UIImage(named: "ic_logout")
            lblTitle.text = "Logout"
            lblDis.text = "Are you sure you want to log out?"
            btnLogout.setTitle("Logout", for: [])
        } else {
            imgLogout.image = UIImage(named: "ic_DeleteAcc")
            lblTitle.text = "Are you sure?"
            lblDis.text = "This action is permanent and cannot be reversed."
            btnLogout.setTitle("Delete", for: [])
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedCancel(_ sender: Any) {
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        
        if isOpenLogout {
            FCUtilites.saveIsGetCurrentUser(false)
            AppDelegate.appDelegate.setUpLogin()
        }
    }
    
    
}
