//
//  FareBreakupVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 27/01/26.
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
    
    @IBOutlet weak var btnCOD: UIButton!
    @IBOutlet weak var btnLink: UIButton!
    
    var fareBreakupVM = FareBreakupVM()
    var bookingPaymentVM = BookingPaymentVM()

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpBookingAmount()
        
        fareBreakupVM.successPromoCode = {
            self.btnApply.setTitle("Remove", for: [])
            self.txtPromoCode.isUserInteractionEnabled = false
            
            self.setUpBookingAmount(isDiscount: true)
        }
        fareBreakupVM.failurePromoCode = { msg in
            self.setUpMakeToast(msg: msg)
        }
        
        bookingPaymentVM.successCreateBooking = {
            let vc = BookingSuccessPopUpVC()
            if let sheet = vc.sheetPresentationController {
                // Create a custom detent that returns a fixed height
                let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                    return 250
                }
                sheet.detents = [fixedDetent]
                sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
            }
            vc.sheetPresentationController?.delegate = self
            if CreateBooking.shared.isScheduleBooking {
                vc.strOpenFrom = "schedule_service"
            } else {
                vc.strOpenFrom = "create_booking"
            }
            self.present(vc, animated: true)
        }
        
        bookingPaymentVM.failureCreateBooking = { msg in
            self.setUpMakeToast(msg: msg)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setUpAmount
    func setUpBookingAmount(isDiscount: Bool = false) {
        let currency = CreateBooking.shared.currency ?? ""
        
        lblBaseFare.text = currency + " " + "\(CreateBooking.shared.price ?? 0.0)"
        lblDiscount.text = isDiscount ? currency + " " + "\(fareBreakupVM.promoCodeData?.discountValue ?? 0)" : currency + " " + "0.0"
        
        let basePrice = Double(CreateBooking.shared.price ?? 0.0)
        let discountValue = Double(fareBreakupVM.promoCodeData?.discountValue ?? 0)
        CreateBooking.shared.discountPrice = "\(fareBreakupVM.promoCodeData?.discountValue ?? 0)"
        CreateBooking.shared.promotion_id = fareBreakupVM.promoCodeData?.id ?? 0
        
        let price = isDiscount ? basePrice - discountValue : basePrice
        
        let configVM = AppDelegate.appDelegate.configVM.configResponse
        
        let platformFee = configVM?.generalSettings.showPlatformFee == true ? "\(configVM?.generalSettings.platformFeeAmount ?? 0.0)" : "0.0"
        let tax = configVM?.generalSettings.showTax == true ? "\(configVM?.generalSettings.taxAmount ?? 0.0)" : "0.0"
        
        lblPlatformFee.text = currency + " " + (platformFee)
        lblTax.text = currency + " " + (tax)
        
        let platformFeeValue = Double(platformFee) ?? 0.00
        let taxValue = Double(tax) ?? 0.0
        
        CreateBooking.shared.platform_fee = platformFee
        CreateBooking.shared.tax = tax
        
        let totalAmount = price + platformFeeValue + taxValue
        lblTotalAmount.text = "\(currency) \(totalAmount)"
        CreateBooking.shared.finalPrice = totalAmount
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
        let vc = BookingConfirmationPopupVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 200
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        vc.isConfirmSchedule = false
        
        vc.onTappedConfirmBooking = {
            /*let vc = BookingPaymentVC()
            self.navigationController?.pushViewController(vc, animated: true)*/
            
            self.bookingPaymentVM.createBookingImg()
        }
        
        self.present(vc, animated: true)
    }
    
    @IBAction func tappedCOD(_ sender: Any) {
        btnCOD.setImage("ic_check".image, for: [])
        btnLink.setImage("ic_uncheck".image, for: [])
    }
    @IBAction func tappledPayLink(_ sender: Any) {
        btnCOD.setImage("ic_uncheck".image, for: [])
        btnLink.setImage("ic_check".image, for: [])
    }
    

}

// MARK: - UISheetPresentationControllerDelegate
extension FareBreakupVC: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let overlayView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                overlayView.alpha = 0
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
            
        }
    }
}
