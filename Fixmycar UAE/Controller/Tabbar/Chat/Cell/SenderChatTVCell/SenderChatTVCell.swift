//
//  SenderChatTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class SenderChatTVCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var chatDetails: MessageDetails? {
        didSet {
            lblMessage.text = chatDetails?.message
            
            let time = chatDetails?.created_at?.toDisplayDate(displayFormat: "hh:mm a")
            lblTime.text = time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
