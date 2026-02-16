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

extension UITapGestureRecognizer {

    func didTapAttributedText(in label: UILabel, inRange targetRange: NSRange) -> Bool {

        guard let attributedText = label.attributedText else { return false }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        let locationOfTouchInLabel = self.location(in: label)

        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(
            x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.origin.y
        )

        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )

        let index = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        return NSLocationInRange(index, targetRange)
    }
}
