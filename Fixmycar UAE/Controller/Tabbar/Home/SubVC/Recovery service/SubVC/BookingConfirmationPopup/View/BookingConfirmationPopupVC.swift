//
//  BookingConfirmationPopupVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 27/01/26.
//

import UIKit

class BookingConfirmationPopupVC: UIViewController {

    @IBOutlet weak var lblTitle: AppLabel!
    @IBOutlet weak var lblMssage: AppLabel!
    
    var onTappedConfirmBooking: (()->Void)?
    var isConfirmSchedule: Bool = false
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = isConfirmSchedule ? "Schedule service" : "Booking confirmation"
        lblTitle.text = title
        
        let message = isConfirmSchedule ? "Please confirm your service schedule. Your service will be assigned to the nearest available driver at that time" : "Please confirm your booking. Your service will be assigned to the nearest available driver shortly."
        lblMssage.text = message
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedConfirm(_ sender: Any) {
        onTappedConfirmBooking?()
        tappedCancel(self)
    }
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
 

}
