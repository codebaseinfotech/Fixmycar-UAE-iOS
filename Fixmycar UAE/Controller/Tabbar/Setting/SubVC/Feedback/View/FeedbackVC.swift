//
//  FeedbackVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var textViewMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSubmit(_ sender: Any) {
        
    }
    
}
