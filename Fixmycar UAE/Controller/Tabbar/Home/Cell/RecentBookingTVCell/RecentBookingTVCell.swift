//
//  RecentBookingTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class RecentBookingTVCell: UITableViewCell {
   
    @IBOutlet weak var viewRecentBooking: RecentBookingsView!
    
    var recentBooking: RecentRequest? {
        didSet {
            viewRecentBooking.lblType.text = recentBooking?.serviceName
            viewRecentBooking.lblTime.text = recentBooking?.dateTime
            viewRecentBooking.lblPrice.text = "AED \(recentBooking?.amount ?? 0)"
            viewRecentBooking.lblStatus.text = recentBooking?.status?.capitalized
            
            if recentBooking?.status == "pending" {
                viewRecentBooking.viewStatus.backgroundColor = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9490196078, alpha: 1)
                viewRecentBooking.viewStatus.borderColor = #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.1921568627, alpha: 1)
                viewRecentBooking.lblStatus.textColor = #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.1921568627, alpha: 1)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(type: String = "recent_booking") {
        if type == "recent_booking" {
            viewRecentBooking.svHistoryMain.isHidden = false
            viewRecentBooking.viewLineAddress.isHidden = false
            viewRecentBooking.svLocation.isHidden = true
            
        }
    }
    
}
