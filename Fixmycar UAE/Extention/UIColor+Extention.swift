//
//  UIColor+Extention.swift
//  TorettoRecovery
//
//  Created by Codebase Infotech on 29/12/25.
//

import Foundation
import UIKit
import Toast

extension UIColor {
    struct AppColor {
        static let started_bg = #colorLiteral(red: 0.8901960784, green: 0.9490196078, blue: 0.9921568627, alpha: 1)
        static let one_way_to_pickup_bg = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.8784313725, alpha: 1)
        static let near_pickup_bg = #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1)
        static let arrived_pick_bg = #colorLiteral(red: 0.9098039216, green: 0.9607843137, blue: 0.9137254902, alpha: 1)
        static let pickup_completed_bg = #colorLiteral(red: 0.8156862745, green: 0.9411764706, blue: 0.7529411765, alpha: 1)
        static let one_way_to_delivery_bg = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.8823529412, alpha: 1)
        static let near_delivery_bg = #colorLiteral(red: 0.9529411765, green: 0.8980392157, blue: 0.9607843137, alpha: 1)
        static let arrived_delivery_bg = #colorLiteral(red: 0.8784313725, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        static let completrd_bg = #colorLiteral(red: 0.8745098039, green: 1, blue: 0.9137254902, alpha: 1)
        static let pending_bg = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9490196078, alpha: 1)
        static let cancelled_bg = #colorLiteral(red: 0.9882352941, green: 0.9294117647, blue: 0.9333333333, alpha: 1)
        
        static let started_border = #colorLiteral(red: 0.05098039216, green: 0.2784313725, blue: 0.631372549, alpha: 1)
        static let one_way_to_pickup_border = #colorLiteral(red: 0.9019607843, green: 0.3176470588, blue: 0, alpha: 1)
        static let near_pickup_border = #colorLiteral(red: 0.007843137255, green: 0.4666666667, blue: 0.7411764706, alpha: 1)
        static let arrived_pick_border = #colorLiteral(red: 0.1058823529, green: 0.368627451, blue: 0.1254901961, alpha: 1)
        static let pickup_completed_border = #colorLiteral(red: 0.1058823529, green: 0.368627451, blue: 0.1254901961, alpha: 1)
        static let one_way_to_delivery_border = #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 1)
        static let near_delivery_border = #colorLiteral(red: 0.4156862745, green: 0.1058823529, blue: 0.6039215686, alpha: 1)
        static let arrived_delivery_border = #colorLiteral(red: 0, green: 0.3764705882, blue: 0.3921568627, alpha: 1)
        static let completrd_border = #colorLiteral(red: 0.2274509804, green: 0.7725490196, blue: 0.4549019608, alpha: 1)
        static let pending_border = #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.1921568627, alpha: 1)
        static let cancelled_border = #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
    }
}




extension UIView {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
     //   gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)

    }
}


class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadius1: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius1
            layer.masksToBounds = cornerRadius1 > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius1 > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius1).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIViewController
{
    func setUpMakeToast(msg: String)
    {
        setUpHideToast()
        self.view.makeToast(msg)
    }

    func setUpHideToast()
    {
        self.view.hideToast()
    }

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}
