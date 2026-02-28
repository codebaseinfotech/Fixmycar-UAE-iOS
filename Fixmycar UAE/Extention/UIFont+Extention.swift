//
//  UIFont+Extention.swift
//  TorettoRecovery
//
//  Created by Codebase Infotech on 29/12/25.
//

import Foundation
import UIKit

extension UIFont {

    struct AppFont {

        static func black(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Black", size: size)!
        }

        static func blackItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-BlackItalic", size: size)!
        }

        static func bold(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Bold", size: size)!
        }

        static func boldItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-BoldItalic", size: size)!
        }

        static func medium(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Medium", size: size)!
        }

        static func mediumItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-MediumItalic", size: size)!
        }

        static func regular(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Regular", size: size)!
        }

        static func italic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Italic", size: size)!
        }

        static func light(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-Light", size: size)!
        }

        static func lightItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Satoshi-LightItalic", size: size)!
        }
    }
}

