//
//  UIImage+Extension.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func loadFromUrlString(_ urlString:String?, placeholder:Placeholder? = "ic_placeholder_user".image, needAccess:Bool = true, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        if (urlString == nil) {
            return
        }
       
        let urStr = urlString?.replacingOccurrences(of: "|", with: "%7c")
        guard let urString = urStr else {return}
        let url = URL(string: urString)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, completionHandler: completionHandler)

    }
    func bottomCornerRedius(redius: CGFloat){
        self.layer.cornerRadius = redius
        self.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

extension UIImage {
    
    func jpegDataSafe(quality: CGFloat = 0.8) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
}
