//
//  AGDesignable.swift
//  Look_Vendor
//
//  Created by Codebase Infotech on 24/07/23.
//

import UIKit
import CoreLocation
import Foundation
// you can set cornerRadius,borderWidth., ect in side storeboard.
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class AppTextView: UITextView {

    @IBInspectable var localizedKey: String = "" {
        didSet {
            text = localizedKey.localized
        }
    }
}

@IBDesignable
class AppTextField: UITextField {

    @IBInspectable var localizedKey: String = "" {
        didSet {
            placeholder = localizedKey.localized
        }
    }
}


@IBDesignable
class AppButton: UIButton {

    @IBInspectable var localizedKey: String = "" {
        didSet {
            setTitle(localizedKey.localized, for: .normal)
        }
    }
}


@IBDesignable
class AppLabel: UILabel {
    
    @IBInspectable var localizedKey: String = "" {
        didSet {
            text = localizedKey.localized
        }
    }
    
    @IBInspectable
    var lineHeight: CGFloat {
        get {
            return 0
        }
        set {
            guard let text = text else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = textAlignment
            
            attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: font as Any,
                    .foregroundColor: textColor as Any
                ]
            )
        }
    }
}


@IBDesignable
class DesignableImageView: UIImageView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
