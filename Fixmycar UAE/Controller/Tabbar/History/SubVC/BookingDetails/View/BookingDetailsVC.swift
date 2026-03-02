//
//  BookingDetailsVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class BookingDetailsVC: UIViewController {

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
    @IBOutlet weak var lblPlatformFee: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    var bookingVM = BookingDetailsVM()
    var chatVM = ChatVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingVM.getBookingDetails()
        bookingVM.successBookingDetails = { [self] in
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
                
                viewStatus.backgroundColor = UIColor.AppColor.completrd_bg
                viewStatus.borderColor = UIColor.AppColor.completrd_border
                
                lblStatus.textColor = UIColor.AppColor.completrd_border
            case .cancelled:
                lblStatus.text = "Cancelled"
                
                viewStatus.backgroundColor = UIColor.AppColor.cancelled_bg
                viewStatus.borderColor = UIColor.AppColor.cancelled_border
            
                lblStatus.textColor = UIColor.AppColor.cancelled_border
            }
            
            lblUserName.text = bookingVM.bookingDetails?.driver?.name
            imgUser.loadFromUrlString(bookingVM.bookingDetails?.driver?.image ?? "", placeholder: "ic_placeholder_user".image)
            lblRating.text = bookingVM.bookingDetails?.driver?.rating ?? "0.0"
            
            lblBaseFare.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.basePrice ?? 0.0)"
            lblDiscount.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.discountAmount ?? 0.0)"
            lblPlatformFee.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.platformFee ?? 0)"
            lblTax.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.tax ?? 0)"
            lblTotalAmount.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.finalPrice ?? 0)"
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
        vc.chatDetailsVM.jobId = booking.id
        vc.profileImg = booking.driver?.image ?? ""
        vc.profileName = booking.driver?.name ?? ""
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
