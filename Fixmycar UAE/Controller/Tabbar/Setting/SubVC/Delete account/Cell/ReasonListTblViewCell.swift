//
//  ReasonListTblViewCell.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/01/26.
//

import UIKit

class ReasonListTblViewCell: UITableViewCell {

    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
