//
//  MyProfileVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtNumber: AppTextField!
    @IBOutlet weak var txtEmail: AppTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEditProfile(_ sender: Any) {
        let vc = EditProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
