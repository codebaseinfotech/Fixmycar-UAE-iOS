//
//  FAQsTblViewCell.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class FAQsTblViewCell: UITableViewCell {

    @IBOutlet weak var lblQuation: UILabel!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var viewMiddelLine: UIView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblAnswer.isHidden = true
        viewMiddelLine.isHidden = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblAnswer.isHidden = true
        viewMiddelLine.isHidden = true
        imgPlus.image = UIImage(named: "ic_plus")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
