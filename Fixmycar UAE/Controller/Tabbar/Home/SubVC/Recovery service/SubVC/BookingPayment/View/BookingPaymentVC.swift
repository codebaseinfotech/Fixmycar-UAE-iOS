//
//  BookingPaymentVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 27/01/26.
//

import UIKit

class BookingPaymentVC: UIViewController {

    @IBOutlet weak var btnPayFull: UIButton!
    @IBOutlet weak var btnPay30: UIButton!
    @IBOutlet weak var lblAmount: AppLabel! 
    @IBOutlet weak var lbl30Description: AppLabel! {
        didSet {
            setBulletText(label: lbl30Description)
        }
    }
    
    var bookingPaymentVM = BookingPaymentVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            vc.isScheduleBooking = false
            self.present(vc, animated: true)
        }
        
        bookingPaymentVM.failureCreateBooking = { msg in
            self.setUpMakeToast(msg: msg)
        }

        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedInfo(_ sender: Any) {
        let popup = InfoPopupView(frame: UIScreen.main.bounds)
        popup.setText(infoText())
        
        UIApplication.shared.windows.first?.addSubview(popup)
    }
    @IBAction func tappedPayFullAmout(_ sender: Any) {
        btnPayFull.setImage("ic_check".image, for: [])
        btnPay30.setImage("ic_uncheck".image, for: [])
    }
    @IBAction func tappedPay30(_ sender: Any) {
        btnPay30.setImage("ic_check".image, for: [])
        btnPayFull.setImage("ic_uncheck".image, for: [])
    }
    @IBAction func tappedPayNow(_ sender: Any) {
        bookingPaymentVM.createBooking()
    }
    
    // MARK: - setUpText 30 PayNow
    func setBulletText(label: UILabel) {

        let text =
        "• Remaining amount payable when driver arrives\n" +
        "• Vehicle will be picked up only after full payment"

        let attributedText = NSMutableAttributedString(string: text)

        let fullRange = NSRange(location: 0, length: attributedText.length)

        // Font
        attributedText.addAttribute(
            .font,
            value: UIFont.AppFont.medium(12),
            range: fullRange
        )

        // Text color
        attributedText.addAttribute(
            .foregroundColor,
            value: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1),
            range: fullRange
        )

        // Line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.alignment = .left

        attributedText.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: fullRange
        )

        label.attributedText = attributedText
    }
    
    // MARK: - setUp InfoText
    func infoText() -> NSAttributedString {

        let text =
        "• Minimum amount is required to confirm the service\n" +
        "• Remaining balance must be paid before vehicle pickup\n" +
        "• Minimum amount is non-refundable in case of customer cancellation\n" +
        "• If service is cancelled by company, amount will be refunded."

        let attributed = NSMutableAttributedString(string: text)

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5

        attributed.addAttribute(.paragraphStyle, value: paragraph,
                                range: NSRange(location: 0, length: attributed.length))

        attributed.addAttribute(.font,
                                value: UIFont.systemFont(ofSize: 13),
                                range: NSRange(location: 0, length: attributed.length))

        attributed.addAttribute(.foregroundColor,
                                value: UIColor.darkGray,
                                range: NSRange(location: 0, length: attributed.length))

        return attributed
    }


    
}

// MARK: - UISheetPresentationControllerDelegate
extension BookingPaymentVC: UISheetPresentationControllerDelegate {
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
