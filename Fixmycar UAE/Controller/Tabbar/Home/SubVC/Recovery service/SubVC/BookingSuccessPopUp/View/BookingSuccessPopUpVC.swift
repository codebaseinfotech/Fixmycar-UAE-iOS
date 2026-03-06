//
//  BookingSuccessPopUpVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 27/01/26.
//

import UIKit

class BookingSuccessPopUpVC: UIViewController {

    @IBOutlet weak var lblTitle: AppLabel!
    @IBOutlet weak var lblMessage: AppLabel!
    
    var strOpenFrom: String = ""
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch strOpenFrom {
        case "create_booking":
            lblTitle.text = "Booking successfully"
            lblMessage.text = "Your service booked\nsuccessfully."
            
            setUpHome(isOpenBooking: true)
        case "schedule_service":
            lblTitle.text = "Scheduled successfully"
            lblMessage.text = "Your service scheduled\nsuccessfully."
            
            setUpHome(isOpenBooking: true)
        case "rate_driver":
            lblTitle.text = "Thank You for Your Feedback!"
            lblMessage.text = "Your review has been posted successfully. We truly appreciate your time and valuable feedback."
            
            setUpHome()
        default:
            break
        }
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - setUpPushHome
    func setUpHome(isOpenBooking: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            AppDelegate.appDelegate.setUpHome()
            
            if isOpenBooking {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    NotificationCenter.default.post(name: .createNewBooking, object: nil)
                }
            }
        }
    }
    

}
