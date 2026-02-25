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
            if bookingVM.bookingDetails?.status == "pending" {
                viewStatus.backgroundColor = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9490196078, alpha: 1)
                viewStatus.borderColor = #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.1921568627, alpha: 1)
                lblStatus.textColor = #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.1921568627, alpha: 1)
            }
            
            lblUserName.text = bookingVM.bookingDetails?.driver?.name
            imgUser.loadFromUrlString(bookingVM.bookingDetails?.driver?.image ?? "", placeholder: "ic_placeholder_user".image)
            lblRating.text = bookingVM.bookingDetails?.driver?.rating ?? "0.0"
            
            lblBaseFare.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.basePrice ?? "")"
            lblDiscount.text = "\(bookingVM.bookingDetails?.currency ?? "") \(bookingVM.bookingDetails?.discountAmount ?? "")"
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
    
    
    
    
}
