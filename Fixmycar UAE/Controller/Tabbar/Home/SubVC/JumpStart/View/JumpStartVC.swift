//
//  JumpStartVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class JumpStartVC: UIViewController {

    @IBOutlet weak var lblTitle: AppLabel!
    @IBOutlet weak var lblDis: AppLabel!
    
    var isHomeOpen: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isHomeOpen {
            lblTitle.text = "Jump start assistant"
            lblDis.text = "Car battery dead? Our team is available to assist you quickly and safety. Jump start service will be available for online booking soon. For immediate assistance, please contact our support team using one of the options below."
        } else {
            lblTitle.text = "Contact support"
            lblDis.text = "We’re here to assist you with bookings, live tracking and any service related queries."
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedChatUs(_ sender: Any) {
        
    }
    @IBAction func tappedCallUs(_ sender: Any) {
        
    }

}
