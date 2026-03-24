//
//  VehicleImageCVCell.swift
//  FixMyCar UAE
//
//  Created by Kenil on 24/03/26.
//

import UIKit

class VehicleImageCVCell: UICollectionViewCell {

    @IBOutlet weak var viewMainUpload: UIView!
    @IBOutlet weak var viewVehicleImageMain: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgClose: UIImageView!

    @IBOutlet weak var imgVehicleImage: UIImageView!
    
    var tappedRemove: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func tappedRemoveVehicleImage(_ sender: UIButton) {
        tappedRemove?(sender.tag)
    }
    
}
