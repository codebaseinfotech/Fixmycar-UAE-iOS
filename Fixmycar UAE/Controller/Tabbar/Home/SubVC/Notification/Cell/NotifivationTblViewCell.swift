//
//  NotifivationTblViewCell.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 23/01/26.
//

import UIKit

class NotifivationTblViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewFirstLatter: UIView!
    @IBOutlet weak var lblFirstlatter: AppLabel!
    @IBOutlet weak var viewUnRead: UIView!
    @IBOutlet weak var lblTitle: AppLabel!
    @IBOutlet weak var lblTime: AppLabel!
    @IBOutlet weak var lblMessage: AppLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
