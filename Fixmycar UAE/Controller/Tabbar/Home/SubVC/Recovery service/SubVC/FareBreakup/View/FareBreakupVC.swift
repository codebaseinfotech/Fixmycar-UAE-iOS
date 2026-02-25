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
    @IBOutlet weak var btnApply: AppButton!
    
    var fareBreakupVM = FareBreakupVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpBookingAmount()
        
        fareBreakupVM.successPromoCode = {
            self.btnApply.setTitle("Remove", for: [])
            self.txtPromoCode.isUserInteractionEnabled = false
            
            self.setUpBookingAmount(isDiscount: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setUpAmount
    func setUpBookingAmount(isDiscount: Bool = false) {
        let currency = CreateBooking.shared.currency ?? ""
        
        lblBaseFare.text = currency + " " + "\(CreateBooking.shared.price ?? "")"
        lblDiscount.text = isDiscount ? currency + " " + "\(fareBreakupVM.promoCodeData?.discountValue ?? 0)" : currency + " " + "0.0"
        
        let basePrice = Double(CreateBooking.shared.price ?? "") ?? 0.0
        let discountValue = Double(fareBreakupVM.promoCodeData?.discountValue ?? 0)
        
        let price = isDiscount ? basePrice - discountValue : basePrice
        
        let configVM = AppDelegate.appDelegate.configVM.configResponse
        
        let platformFee = configVM?.generalSettings.showPlatformFee == true ? configVM?.generalSettings.platformFeeAmount : currency + " " + "0.0"
        let tax = configVM?.generalSettings.showTax == true ? configVM?.generalSettings.taxAmount : currency + " " + "0.0"
        
        lblPlatformFee.text = currency + " " + (platformFee ?? "")
        lblTax.text = currency + " " + (tax ?? "")
        
        let platformFeeValue = Double(platformFee ?? "0.0") ?? 0.00
        let taxValue = Double(tax ?? "0.0") ?? 0.0
        
        let totalAmount = price + platformFeeValue + taxValue
        lblTotalAmount.text = "\(currency) \(totalAmount)"
        CreateBooking.shared.finalPrice = "\(totalAmount)"
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedApply(_ sender: UIButton) {
        if sender.titleLabel?.text == "Remove" {
            self.btnApply.setTitle("Apply", for: [])
            self.txtPromoCode.isUserInteractionEnabled = true
            txtPromoCode.text = ""
            
            self.setUpBookingAmount()
        } else {
            guard let promoCode = txtPromoCode.text, !promoCode.isEmpty else {
                self.setUpMakeToast(msg: "Please enter promo code")
                return
            }
            
            fareBreakupVM.getPromoCode(promoCode: promoCode)
        }
    }
    @IBAction func tappedProceedToPay(_ sender: Any) {        
        let vc = BookingPaymentVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
