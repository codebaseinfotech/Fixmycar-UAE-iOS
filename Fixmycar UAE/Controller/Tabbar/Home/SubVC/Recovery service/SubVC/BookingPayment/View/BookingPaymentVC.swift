//
//  BookingPaymentVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 27/01/26.
//

import UIKit
import StripePaymentSheet

// MARK: - Payment Type Enum
enum PaymentType: String {
    case full = "full"
    case partial = "partial"  // 30% now, 70% later
}

class BookingPaymentVC: UIViewController {

    @IBOutlet weak var btnPayFull: UIButton!
    @IBOutlet weak var btnPay30: UIButton!
    @IBOutlet weak var lblAmount: AppLabel!
    @IBOutlet weak var lbl30Description: AppLabel! {
        didSet {
            setBulletText(label: lbl30Description)
        }
    }

    // Selected payment type (default: full)
    var selectedPaymentType: PaymentType = .full

    var bookingPaymentVM = BookingPaymentVM()

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAmount.text = "\(CreateBooking.shared.currency ?? "") \(CreateBooking.shared.finalPrice ?? 0.0)"
        
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

        // Payment Intent Callbacks
        bookingPaymentVM.successPaymentIntent = { [weak self] paymentData in
            guard let self = self else { return }
            self.presentStripePaymentSheet(paymentData: paymentData)
        }

        bookingPaymentVM.failurePaymentIntent = { [weak self] msg in
            self?.setUpMakeToast(msg: msg)
        }
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
        selectedPaymentType = .full
        btnPayFull.setImage("ic_check".image, for: [])
        btnPay30.setImage("ic_uncheck".image, for: [])
    }

    @IBAction func tappedPay30(_ sender: Any) {
        selectedPaymentType = .partial
        btnPay30.setImage("ic_check".image, for: [])
        btnPayFull.setImage("ic_uncheck".image, for: [])
    }

    @IBAction func tappedPayNow(_ sender: Any) {
        let vc = BookingConfirmationPopupVC()
        if let sheet = vc.sheetPresentationController {
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 200
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true
        }
        vc.sheetPresentationController?.delegate = self
        vc.isConfirmSchedule = false

        vc.onTappedConfirmBooking = { [weak self] in
            guard let self = self else { return }

            // Set payment method to card for Stripe
            CreateBooking.shared.payment_method = "card"

            // Calculate amount based on payment type
            let paymentAmount = self.calculatePaymentAmount()

            // Create payment intent with the calculated amount
            self.bookingPaymentVM.createPaymentIntent(
                amount: paymentAmount,
                paymentType: self.selectedPaymentType.rawValue
            )
        }

        self.present(vc, animated: true)
    }

    // MARK: - Calculate Payment Amount
    private func calculatePaymentAmount() -> Double {
        let totalPrice = CreateBooking.shared.finalPrice ?? 0.0

        switch selectedPaymentType {
        case .full:
            return totalPrice
        case .partial:
            // Fixed AED 50 advance payment
            // If total is less than 50, pay full amount
            return min(50.0, totalPrice)
        }
    }

    // MARK: - Present Stripe Payment Sheet
    private func presentStripePaymentSheet(paymentData: PaymentIntentData) {
        guard let clientSecret = paymentData.clientSecret else {
            setUpMakeToast(msg: "Invalid payment configuration")
            return
        }

        StripeManager.shared.presentPaymentSheet(
            paymentIntentClientSecret: clientSecret,
            customerID: paymentData.customerId,
            ephemeralKeySecret: paymentData.ephemeralKey,
            from: self
        ) { [weak self] result in
            self?.handleStripePaymentResult(result)
        }
    }

    // MARK: - Handle Stripe Payment Result
    private func handleStripePaymentResult(_ result: PaymentSheetResult) {
        StripeManager.shared.handlePaymentResult(result) { [weak self] success, errorMessage in
            guard let self = self else { return }

            if success {
                // Payment successful, now create the booking
                self.bookingPaymentVM.createBookingImg()
            } else if let error = errorMessage {
                // Payment failed or canceled
                if error != "Payment was canceled" {
                    self.setUpMakeToast(msg: error)
                }
            }
        }
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
