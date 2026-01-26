//
//  String+Extention.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation

extension UILabel {
    func setLineHeight(_ lineHeight: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        self.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: self.font!,
                .foregroundColor: self.textColor!
            ]
        )
    }
}

extension String {
    var image: UIImage {
        guard let image = UIImage(named: self) else {
            return UIImage()
        }

        return image
    }

    
    func convertHTMLToPlainText() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString.string
        } catch {
            return nil
        }
    }
    
    func htmlToString(html: String) -> String? {
        guard let data = html.data(using: .utf8) else { return nil }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            return attributedString.string
        } catch {
            debugPrint("Error converting HTML to String: \(error)")
            return nil
        }
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


// MARK: - NSMutableData
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIView {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var identifier: String {
        String(describing: self)
    }
}
