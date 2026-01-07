//
//  RecentBookingTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class RecentBookingTVCell: UITableViewCell {

    @IBOutlet weak var imgBooking: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblLocaation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var svHisotyMain: UIStackView!
    @IBOutlet weak var svLocation: UIStackView!
    
    @IBOutlet weak var lblPickLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    
    @IBOutlet weak var viewLineHistory: UIView!
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
            svLocation.isHidden = false
            svHisotyMain.isHidden = true
            viewLineHistory.isHidden = true
            
        } else if type == "history_booking" {
            svLocation.isHidden = true
            svHisotyMain.isHidden = false
            viewLineHistory.isHidden = false
            
        }
    }
    
}
