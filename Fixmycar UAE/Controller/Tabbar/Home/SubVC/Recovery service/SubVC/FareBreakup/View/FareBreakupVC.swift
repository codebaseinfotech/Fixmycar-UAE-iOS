//
//  FareBreakupVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 27/01/26.
//

import UIKit

class FareBreakupVC: UIViewController {

    @IBOutlet weak var txtPromoCode: AppTextField!
    
    @IBOutlet weak var lblBaseFare: AppLabel!
    @IBOutlet weak var lblDiscount: AppLabel!
    @IBOutlet weak var lblPlatformFee: AppLabel!
    @IBOutlet weak var lblTax: AppLabel!
    @IBOutlet weak var lblTotalAmount: AppLabel!
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedApply(_ sender: Any) {
    }
    @IBAction func tappedProceedToPay(_ sender: Any) {
        let vc = BookingPaymentVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
