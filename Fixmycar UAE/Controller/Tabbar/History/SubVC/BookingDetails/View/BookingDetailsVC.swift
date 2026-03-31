//
//  BookingDetailsVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
//

import UIKit

class BookingDetailsVC: UIViewController {

    
    @IBOutlet weak var viewIncoice1: UIView!
    
    @IBOutlet weak var lblInvoiceName: UILabel!
    @IBOutlet weak var imgRecovery: UIImageView!
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel! {
        didSet {
            lblStatus.textAlignment = .center
        }
    }
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var lblGulfside: UILabel!
    @IBOutlet weak var lblGulfYear: UILabel!
    @IBOutlet weak var viewGulfsideMain: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblVehicleNumTitle: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblVehicleNum: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblAdminDiscount: UILabel!

    @IBOutlet weak var lblPlatformFee: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var viewMainDriver: UIView!
    @IBOutlet weak var viewLineBottomLocation: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isHidden = true
        }
    }
    @IBOutlet weak var lblCancelBu: UILabel!
    @IBOutlet weak var lblCancelReasib: UILabel!
    
    @IBOutlet weak var imgDriverReview: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var viewReviewDriver: HCSStarRatingView!
    @IBOutlet weak var lblCountReview: UILabel!
    @IBOutlet weak var lblReviewTime: UILabel!
    @IBOutlet weak var lblReviewDis: UILabel!
    @IBOutlet weak var btnGiveReview: UIButton!
    @IBOutlet weak var viewMainRatingDetail: UIView!
    @IBOutlet weak var lblBookingID: UILabel!
    
    var bookingVM = BookingDetailsVM()
    var chatVM = ChatVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingVM.getBookingDetails()
        bookingVM.successBookingDetails = { [self] in
            
            scrollView.isHidden = false
            
            lblServiceTitle.text = bookingVM.bookingDetails?.serviceType
            lblTime.text = bookingVM.bookingDetails?.createdAt?.toDisplayDate()
            lblPickup.text = bookingVM.bookingDetails?.pickupAddress
            lblDrop.text = bookingVM.bookingDetails?.dropoffAddress
            lblStatus.text = bookingVM.bookingDetails?.status?.capitalized
            
            let jobStatus: JobStatus = JobStatus(rawValue: bookingVM.bookingDetails?.status ?? "") ?? .accepted
            
            switch jobStatus {
            case .pending:
                lblStatus.text = "Pending"
                
                viewStatus.backgroundColor = UIColor.AppColor.pending_bg
                viewStatus.borderColor = UIColor.AppColor.pending_border
                lblStatus.textColor = UIColor.AppColor.pending_border
                
            case .accepted:
                lblStatus.text = "Accepted"
                
                viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewStatus.borderColor = UIColor.AppColor.started_border
                
                lblStatus.textColor = UIColor.AppColor.started_border
            case .started:
                lblStatus.text = "Started"
                
                viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewStatus.borderColor = UIColor.AppColor.started_border
                
                lblStatus.textColor = UIColor.AppColor.started_border
            case .onTheWayToPickup:
                lblStatus.text = "On the way to pickup"
                
                viewStatus.backgroundColor = UIColor.AppColor.one_way_to_pickup_bg
                viewStatus.borderColor = UIColor.AppColor.one_way_to_pickup_border
                
                lblStatus.textColor = UIColor.AppColor.one_way_to_pickup_border
            case .nearPickup:
                lblStatus.text = "Near pickup"
                
                viewStatus.backgroundColor = UIColor.AppColor.near_pickup_bg
                viewStatus.borderColor = UIColor.AppColor.near_pickup_border
                
                lblStatus.textColor = UIColor.AppColor.near_pickup_border
            case .arrivedAtPickup:
                lblStatus.text = "Arrived at pickup"
                
                viewStatus.backgroundColor = UIColor.AppColor.arrived_pick_bg
                viewStatus.borderColor = UIColor.AppColor.arrived_pick_border
                
                lblStatus.textColor = UIColor.AppColor.arrived_pick_border
            case .pickupCompleted:
                lblStatus.text = "Pickup completed"
                
                viewStatus.backgroundColor = UIColor.AppColor.pickup_completed_bg
                viewStatus.borderColor = UIColor.AppColor.pickup_completed_border
                
                lblStatus.textColor = UIColor.AppColor.pickup_completed_border
            case .onTheWayToDelivery:
                lblStatus.text = "On the way to delivery"
                
                viewStatus.backgroundColor = UIColor.AppColor.one_way_to_delivery_bg
                viewStatus.borderColor = UIColor.AppColor.one_way_to_delivery_border
                
                lblStatus.textColor = UIColor.AppColor.one_way_to_delivery_border
            case .nearDelivery:
                lblStatus.text = "Near delivery"
                
                viewStatus.backgroundColor = UIColor.AppColor.near_delivery_bg
                viewStatus.borderColor = UIColor.AppColor.near_delivery_border
                
                lblStatus.textColor = UIColor.AppColor.near_delivery_border
            case .arrivedAtDelivery:
                lblStatus.text = "Arrived at delivery"
                
                viewStatus.backgroundColor = UIColor.AppColor.arrived_delivery_bg
                viewStatus.borderColor = UIColor.AppColor.arrived_delivery_border
                
                lblStatus.textColor = UIColor.AppColor.arrived_delivery_border
            case .completed:
                lblStatus.text = "Completed"
                
                viewIncoice1.isHidden = false
                
                viewStatus.backgroundColor = UIColor.AppColor.completrd_bg
                viewStatus.borderColor = UIColor.AppColor.completrd_border
                
                lblStatus.textColor = UIColor.AppColor.completrd_border
            case .cancelled:
                lblStatus.text = "Cancelled"
                
                viewStatus.backgroundColor = UIColor.AppColor.cancelled_bg
                viewStatus.borderColor = UIColor.AppColor.cancelled_border
            
                lblStatus.textColor = UIColor.AppColor.cancelled_border
            }
            
            viewMainDriver.isHidden = bookingVM.bookingDetails?.driver != nil ? false : true
            
            lblCancelBu.isHidden = bookingVM.bookingDetails?.cancelReason != nil ? false : true
            lblCancelReasib.isHidden = bookingVM.bookingDetails?.cancelReason != nil ? false : true
            
            let cancelReason = bookingVM.bookingDetails?.cancelReason ?? ""
            let cancelReasonText = bookingVM.bookingDetails?.cancelReasonText ?? ""
             
            lblCancelBu.isHidden = cancelReason != "" || cancelReasonText != "" ? false : true
            lblCancelReasib.isHidden = cancelReason != "" || cancelReasonText != "" ? false : true
            
            var reason = ""
            
            if bookingVM.bookingDetails?.cancelledBy == "customer" {
                reason = "Cancelled by you"
            } else if bookingVM.bookingDetails?.cancelledBy == "driver" {
                reason = "Cancelled by the \(bookingVM.bookingDetails?.cancelledBy ?? "")"
            } else {
                reason = "Cancelled by the" + " " + "Auto cancelled"
            }
            
            lblCancelBu.text = reason
            
            let cancelText = cancelReasonText != "" ? cancelReasonText : cancelReason
            lblCancelReasib.text = "Reason:".localized + " " + cancelText
            
            lblUserName.text = bookingVM.bookingDetails?.driver?.name
            imgUser.loadFromUrlString(bookingVM.bookingDetails?.driver?.image ?? "", placeholder: "ic_placeholder_user".image)
            lblRating.text = "\(bookingVM.bookingDetails?.driverAverageRating ?? 0.0)"
            
            lblVehicleType.text = bookingVM.bookingDetails?.driver?.vehicleModel ?? "-"
            lblVehicleNum.text = bookingVM.bookingDetails?.driver?.vehicleNumber ?? "-"
            
            lblBookingID.text = "Booking ID".localized + ":" + " " + "\(bookingVM.bookingDetails?.bookingId ?? 0)"
            
            lblInvoiceName.text = bookingVM.bookingDetails?.invoiceNumber ?? ""
            
            imgDriverReview.loadFromUrlString(bookingVM.bookingDetails?.driver?.image ?? "", placeholder: "ic_placeholder_user".image)
            lblDriverName.text = bookingVM.bookingDetails?.driver?.name ?? ""
            lblReviewDis.text = bookingVM.bookingDetails?.driverReview?.review ?? ""
            viewReviewDriver.value = CGFloat(bookingVM.bookingDetails?.driverReview?.rating ?? 0)
            lblCountReview.text = "\(bookingVM.bookingDetails?.driverReview?.rating ?? 0)"
            lblReviewTime.text = bookingVM.bookingDetails?.driverReview?.createdAt?.timeAgo() ?? ""
            
            let hasReview = bookingVM.bookingDetails?.driverReview != nil
            let canRate = bookingVM.bookingDetails?.isAvalabRating ?? false

            viewMainRatingDetail.isHidden = !hasReview
            btnGiveReview.isHidden = hasReview || !canRate
            
            lblBaseFare.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.baseFare ?? 0.0)"
            lblDiscount.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.discount ?? 0.0)"
            lblAdminDiscount.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.manual_discount_price ?? 0.0)"
            lblPlatformFee.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.platformFee ?? 0)"
            lblTax.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.tax ?? 0)"
            lblTotalAmount.text = "\(bookingVM.bookingDetails?.invoice?.currency ?? "") \(bookingVM.bookingDetails?.invoice?.totalAmount ?? 0)"
        }
        
        bookingVM.failureBookingDetails = { msg in
            self.setUpMakeToast(msg: msg)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func clickedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickedInvoice(_ sender: Any) {
        let link = bookingVM.bookingDetails?.invoiceURL ?? ""
        guard let url = URL(string: link) else {
            debugPrint("Invalid URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func tappedChat(_ sender: Any) {
        guard let booking = bookingVM.bookingDetails else { return }
        
        let vc = UserChatVC()
        vc.jobStatus = booking.status ?? ""
        vc.chatDetailsVM.bookingId = booking.id
        vc.profileImg = booking.driver?.image ?? ""
        vc.profileName = booking.driver?.name ?? ""
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedGiveReview(_ sender: Any) {
        let vc = AddRateVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 330
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true
        }
        vc.sheetPresentationController?.delegate = self
        vc.addRateVM.bookingId = bookingVM.bookingDetails?.bookingId ?? 0
        vc.tappedSubmit = { [weak self] in
            
            let successVC = BookingSuccessPopUpVC()
            successVC.modalPresentationStyle = .pageSheet
            
            successVC.onReviewSuccess = { [weak self] in
                self?.bookingVM.getBookingDetails()
            }
            
            if let sheet = successVC.sheetPresentationController {
                let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed250")) { _ in
                    return 280
                }
                sheet.detents = [fixedDetent]
                sheet.prefersGrabberVisible = true
            }
            
            successVC.sheetPresentationController?.delegate = self
            successVC.strOpenFrom = "rate_driver_customer"
            self?.present(successVC, animated: true)
        }
        self.present(vc, animated: true)
    }
    
}

// MARK: - UISheetPresentationControllerDelegate
extension BookingDetailsVC: UISheetPresentationControllerDelegate {
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
