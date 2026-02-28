//
//  AppUtilites.swift
//  Look_Vendor
//
//  Created by Codebase Infotech on 24/07/23.
//

import UIKit
import Foundation

class AppUtilites: NSObject {
    
    class var sharedInstance: AppUtilites {
        struct Static {
            static let instance: AppUtilites = AppUtilites()
        }
        return Static.instance
    }
    
    var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }

    var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
    
    class var deviceHasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    func getViewController(controllerName: String) -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: controllerName)
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func validateMobile(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }

   class func isValidPassword(value: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total

        value.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: value)
    }
    
    class func isPasswordValid(_ Password : String) -> Bool{
        let Password = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z](?=.*[0-9].{>6}$")
        return Password.evaluate(with: Password)
    }

    
    // MARK: - AlertView
    
    class func showAlert(title: String, message: String, cancelButtonTitle: String) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: cancelButtonTitle, style: .default))
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
    class func showAlert(title: String, message: String, actionButtonTitle: String, completionHandler : @escaping () -> Void) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
    class func showAlert(title: String, message: String, actionButtonTitle: String, cancelButtonTitle: String, completionHandler : @escaping () -> Void) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        
        alertView.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        
        window.visibleViewController?.present(alertView, animated: true)
        
    }
    
}

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

extension UIDevice {
    var hasNotch: Bool
    {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
    
    /*
     if UIDevice.current.hasNotch
     {
         //... consider notch
     }
     else
     {
        //... don't have to consider notch
     }
     */
}


class Language : NSObject {
    static let shared:Language = Language()
    let APPLE_LANGUAGE_KEY = "AppleLanguages"
    
    var currentAppLang:String {
        return self.isArabic ? "ar" : "en"
    }
    var isArabic:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isLangugeSet")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isLangugeSet")
        }
    }
    
    
    override init() {
        super.init()
    }
}

func setSemantricFlow() {
    if Language.shared.isArabic {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
        UITableView.appearance().semanticContentAttribute = .forceRightToLeft
        UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
        UIVisualEffectView.appearance().semanticContentAttribute = .forceRightToLeft
    } else {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
        UITableView.appearance().semanticContentAttribute = .forceLeftToRight
        UIVisualEffectView.appearance().semanticContentAttribute = .forceLeftToRight
        UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
    }
}

extension String {
    func localizeString(string: String) -> String {
        let path = Bundle.main.path(forResource: string, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
