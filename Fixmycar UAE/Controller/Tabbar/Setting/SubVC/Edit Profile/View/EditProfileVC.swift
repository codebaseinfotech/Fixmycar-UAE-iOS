//
//  EditProfileVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtNumber: AppTextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCamera(_ sender: Any) {
    }
 
    @IBAction func tappedSaveChanges(_ sender: Any) {
    }
    
}
