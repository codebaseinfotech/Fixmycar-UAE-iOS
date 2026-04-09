//
//  BookingPaymentVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 27/01/26.
//

import UIKit
import SafariServices

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

    /// true = full payment, false = partial (50 AED minimum)
    private var isFullPaymentSelected: Bool = true
    private let minimumPartialAmount: Double = 50.0
    private var safariVC: SFSafariViewController?

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAmount.text = "\(CreateBooking.shared.currency ?? "") \(CreateBooking.shared.finalPrice ?? 0.0)"

        bookingPaymentVM.successCheckoutUrl = { [weak self] checkoutUrl in
            self?.openStripeCheckout(url: checkoutUrl)
        }

        bookingPaymentVM.failureCheckoutUrl = { [weak self] msg in
            self?.setUpMakeToast(msg: msg)
        }

        bookingPaymentVM.successPaymentStatus = { [weak self] in
            self?.showBookingSuccessPopup()
        }

        bookingPaymentVM.failurePaymentStatus = { [weak self] msg in
            self?.setUpMakeToast(msg: msg)
        }

        // Listen for payment redirect from URL scheme
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePaymentRedirect(_:)),
            name: .paymentRedirectReceived,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Handle Payment Redirect
    @objc private func handlePaymentRedirect(_ notification: Notification) {
        // Dismiss Safari and check payment status
        safariVC?.dismiss(animated: true) { [weak self] in
            self?.bookingPaymentVM.checkPaymentStatus()
        }
    }

    // MARK: - Show Booking Success Popup
    private func showBookingSuccessPopup() {
        let vc = BookingSuccessPopUpVC()
        if let sheet = vc.sheetPresentationController {
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 250
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true
        }
        vc.sheetPresentationController?.delegate = self
        if CreateBooking.shared.isScheduleBooking {
            vc.strOpenFrom = "schedule_service"
        } else {
            vc.strOpenFrom = "create_booking"
        }
        self.present(vc, animated: true)
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
        isFullPaymentSelected = true
        btnPayFull.setImage("ic_check".image, for: [])
        btnPay30.setImage("ic_uncheck".image, for: [])
    }
    @IBAction func tappedPay30(_ sender: Any) {
        isFullPaymentSelected = false
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
            let amount = self.isFullPaymentSelected
                ? (CreateBooking.shared.finalPrice ?? 0.0)
                : self.minimumPartialAmount
            self.bookingPaymentVM.getTripPrepaymentUrl(amount: amount)
        }

        self.present(vc, animated: true)
    }

    // MARK: - Open Stripe Checkout
    private func openStripeCheckout(url: String) {
        guard let checkoutUrl = URL(string: url) else {
            setUpMakeToast(msg: "Invalid checkout URL")
            return
        }
        safariVC = SFSafariViewController(url: checkoutUrl)
        safariVC?.delegate = self
        present(safariVC!, animated: true)
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

// MARK: - SFSafariViewControllerDelegate
extension BookingPaymentVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // User closed Safari - check payment status
        bookingPaymentVM.checkPaymentStatus()
    }
}
