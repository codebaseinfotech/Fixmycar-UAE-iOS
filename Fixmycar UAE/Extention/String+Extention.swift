//
//  String+Extention.swift
//  TorettoRecovery
//
//  Created by Codebase Infotech on 29/12/25.
//

import Foundation
import UIKit

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
                       displayFormat: String = "dd MMM, yyyy HH:mm",
                       apiTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!,
                       displayTimeZone: TimeZone = TimeZone.current) -> String {
        
        guard let date = self.toDate(withFormat: apiFormat, timeZone: apiTimeZone) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = displayFormat
        displayFormatter.timeZone = displayTimeZone
        return displayFormatter.string(from: date)
    }
    
    func timeAgo() -> String {

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC

        guard let date = formatter.date(from: self) else { return "" }

        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full

        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }

    /// Convert API date string to relative time (e.g., "5 mins ago", "2 hours ago")
    func toRelativeTime(apiFormat: String = "yyyy-MM-dd HH:mm:ss",
                        apiTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!) -> String {

        guard let date = self.toDate(withFormat: apiFormat, timeZone: apiTimeZone) else { return self }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 min ago" : "\(minutes) mins ago"
        }

        return "Just now"
    }

    /// Convert API date string to WhatsApp-style format
    /// - Today: "12:10 PM"
    /// - Yesterday: "Yesterday"
    /// - This week: "Monday", "Tuesday", etc.
    /// - Older: "07/03/26"
    func toWhatsAppStyleDate(apiFormat: String = "dd/MM/yy hh:mm a",
                              apiTimeZone: TimeZone = TimeZone.current) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = apiFormat
        inputFormatter.timeZone = apiTimeZone
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: self) else { return self }

        let calendar = Calendar.current
        let now = Date()

        let formatter = DateFormatter()
        formatter.timeZone = .current

        // Check if today
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        // Check if yesterday
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        // Check if within last 7 days
        let daysAgo = calendar.dateComponents([.day], from: date, to: now).day ?? 0
        if daysAgo < 7 {
            formatter.dateFormat = "EEEE" // Full day name (Monday, Tuesday, etc.)
            return formatter.string(from: date)
        }

        // Older than a week - show date
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }

    /// Get date key for grouping messages (returns just the date portion: "2026-03-10")
    func toDateKey(apiFormat: String = "yyyy-MM-dd HH:mm:ss",
                   apiTimeZone: TimeZone = TimeZone.current) -> String {
        guard let date = self.toDate(withFormat: apiFormat, timeZone: apiTimeZone) else { return self }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }

    /// Get WhatsApp-style section header for chat (Today, Yesterday, Monday, or date)
    func toChatSectionHeader(apiFormat: String = "yyyy-MM-dd HH:mm:ss",
                              apiTimeZone: TimeZone = TimeZone.current) -> String {
        guard let date = self.toDate(withFormat: apiFormat, timeZone: apiTimeZone) else { return self }

        let calendar = Calendar.current
        let now = Date()

        // Check if today
        if calendar.isDateInToday(date) {
            return "Today"
        }

        // Check if yesterday
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        // Check if within last 7 days
        let daysAgo = calendar.dateComponents([.day], from: date, to: now).day ?? 0
        if daysAgo < 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Full day name
            formatter.timeZone = .current
            return formatter.string(from: date)
        }

        // Older than a week - show date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.timeZone = .current
        return formatter.string(from: date)
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

extension String {
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter.date(from: self)
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

// MARK: - hour to min
extension String {

    func toMinutes() -> Int {
        var totalMinutes = 0

        let lower = self.lowercased()
        let components = lower.components(separatedBy: " ")

        for (index, value) in components.enumerated() {
            if let number = Int(value) {

                if index + 1 < components.count {
                    let unit = components[index + 1]

                    if unit.contains("hour") {
                        totalMinutes += number * 60
                    } else if unit.contains("mins") {
                        totalMinutes += number
                    } else {
                        totalMinutes += number
                    }
                }
            }
        }

        return totalMinutes
    }
}

// MARK: - UITextView HTML
extension UITextView {

    func setHTML(_ html: String, fontSize: CGFloat = 14, textColor: UIColor = .black) {
        let fontName = "Satoshi-Regular"
        let linkColor = UIColor(hexString: "#007AFF")

        // Convert plain text phone numbers and emails to clickable links
        var processedHTML = html

        // Convert phone numbers to tel: links (handles formats like +971 523003423, +971-52-300-3423, etc.)
        let phonePattern = #"(?<!</a>|href=[\"'])(\+?\d[\d\s\-]{8,}\d)(?![\"'])"#
        if let phoneRegex = try? NSRegularExpression(pattern: phonePattern, options: []) {
            let range = NSRange(processedHTML.startIndex..., in: processedHTML)
            let matches = phoneRegex.matches(in: processedHTML, options: [], range: range)

            // Process matches in reverse to maintain correct indices
            for match in matches.reversed() {
                if let matchRange = Range(match.range, in: processedHTML) {
                    let phoneNumber = String(processedHTML[matchRange])
                    let cleanPhone = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                    let replacement = "<a href=\"tel:\(cleanPhone)\">\(phoneNumber)</a>"
                    processedHTML.replaceSubrange(matchRange, with: replacement)
                }
            }
        }

        // Convert email addresses to mailto: links
        let emailPattern = #"(?<!</a>|href=[\"'])([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(?![\"'])"#
        if let emailRegex = try? NSRegularExpression(pattern: emailPattern, options: []) {
            let range = NSRange(processedHTML.startIndex..., in: processedHTML)
            processedHTML = emailRegex.stringByReplacingMatches(
                in: processedHTML,
                options: [],
                range: range,
                withTemplate: "<a href=\"mailto:$1\">$1</a>"
            )
        }

        let styledHTML = """
        <html>
        <head>
        <style>
        body {
            font-family: '\(fontName)', -apple-system, sans-serif;
            font-size: \(fontSize)px;
            color: \(textColor.hexString);
            line-height: 1.5;
        }
        a {
            color: \(linkColor.hexString);
            text-decoration: none;
        }
        </style>
        </head>
        <body>\(processedHTML)</body>
        </html>
        """

        guard let data = styledHTML.data(using: .utf8) else { return }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        if let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) {
            self.attributedText = attributedString
        }

        // Enable clickable links
        self.isEditable = false
        self.isSelectable = true
        self.linkTextAttributes = [
            .foregroundColor: linkColor
        ]
    }
}
