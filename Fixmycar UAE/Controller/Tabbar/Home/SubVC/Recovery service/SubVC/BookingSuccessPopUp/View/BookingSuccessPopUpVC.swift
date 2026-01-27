//
//  BookingSuccessPopUpVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 27/01/26.
//

import UIKit

class BookingSuccessPopUpVC: UIViewController {

    @IBOutlet weak var lblTitle: AppLabel! {
        didSet {
            lblTitle.text = isScheduleBooking ? "Scheduled successfully" : "Booking successfully"
        }
    }
    @IBOutlet weak var lblMessage: AppLabel! {
        didSet {
            lblMessage.text = isScheduleBooking ? "Your service scheduled\nsuccessfully." : "Your service booked\nsuccessfully."
        }
    }
    
    var isScheduleBooking: Bool = false
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            AppDelegate.appDelegate.setUpHome()
        }

        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    

}
