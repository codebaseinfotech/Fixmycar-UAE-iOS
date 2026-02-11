//
//  String+Extention.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation

extension String {

    func attributedText(
        defaultFont: UIFont,
        defaultColor: UIColor = .black,
        highlightText: String,
        highlightColor: UIColor = .red
    ) -> NSAttributedString {

        let attributedString = NSMutableAttributedString(
            string: self,
            attributes: [
                .font: defaultFont,
                .foregroundColor: defaultColor
            ]
        )

        let ranges = self.ranges(of: highlightText)
        for range in ranges {
            let nsRange = NSRange(range, in: self)
            attributedString.addAttribute(
                .foregroundColor,
                value: highlightColor,
                range: nsRange
            )
        }

        return attributedString
    }

    // Helper to find multiple occurrences
    private func ranges(of searchText: String) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var startIndex = self.startIndex

        while startIndex < self.endIndex,
              let range = self.range(of: searchText, range: startIndex..<self.endIndex) {
            result.append(range)
            startIndex = range.upperBound
        }
        return result
    }
}


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
    
    /// Convert API date string to Date object
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.date(from: self)
    }
    
    /// Convert API date string to display string
    func toDisplayDate(apiFormat: String = "yyyy-MM-dd HH:mm:ss",
                       displayFormat: String = "dd MMM, yyyy hh:mm a",
                       apiTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!,
                       displayTimeZone: TimeZone = TimeZone.current) -> String {
        
        guard let date = self.toDate(withFormat: apiFormat, timeZone: apiTimeZone) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = displayFormat
        displayFormatter.timeZone = displayTimeZone
        return displayFormatter.string(from: date)
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
