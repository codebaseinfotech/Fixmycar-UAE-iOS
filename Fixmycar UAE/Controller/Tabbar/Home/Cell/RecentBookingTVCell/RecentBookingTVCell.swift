//
//  RecentBookingTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class RecentBookingTVCell: UITableViewCell {
   
    @IBOutlet weak var viewRecentBooking: RecentBookingsView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*func config(type: String = "recent_booking") {
        if type == "recent_booking" {
            svLocation.isHidden = false
            svHisotyMain.isHidden = true
            viewLineHistory.isHidden = true
            
        } else if type == "history_booking" {
            svLocation.isHidden = true
            svHisotyMain.isHidden = false
            viewLineHistory.isHidden = false
            
        }
    }*/
    
}
