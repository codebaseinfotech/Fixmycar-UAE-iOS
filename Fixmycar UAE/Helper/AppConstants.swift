//
//  AppConstants.swift
//  Look_Vendor
//
//  Created by Ankit Gabani on 24/07/23.
//

import Foundation
import UIKit


extension UIViewController: Identifiable {
    
    static func instantiate(_ storyBoardName: String = "Main") ->
        UIViewController {
            let sceneStoryboard = UIStoryboard(name: storyBoardName, bundle: .main)

            return sceneStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

protocol Identifiable: AnyObject {
   /**
    The identifier to use when registering and later dequeuing
    a reusable cell. This will also acts as storyboardIdentifiers.
    */
   static var identifier: String { get }
}

/**
Make your `UITableViewCell` and `UICollectionViewCell` subclasses
conform to this typealias when they *are* NIB-based
to be able to dequeue them in a type-safe manner
*/
typealias NibReusable = Identifiable & NibLoadable

// MARK: - Default implementation

extension Identifiable {
   /**
    By default, use the name of the class as String for its reuseIdentifier
    */
   static var identifier: String {
       return String(describing: self)
   }
}

protocol NibLoadable: AnyObject {
    /**
     A `get-only` stored property for getting the name of nib. This property
     should not be set from an external class/structure.
     */
    static var nibName: String { get }
}

// MARK: - Default implementation

extension NibLoadable where Self: UIView {
    /**
     By default, use the name of the class as String for its reuseIdentifier
     */
    static var nibName: String {
        return String(describing: self)
    }

    /**
     Returns a `UINib` object with the name of `nibName` of the view from XIB.
    */
    static func nibForFile() -> UINib {
        return UINib(nibName: self.nibName, bundle: Bundle(for: self))
    }

    /**
     Returns a `UIView` object instantiated from nib
     - returns: A `NibLoadable`, `UIView` instance
     */
    static func instantiateFromNib() -> Self {
        return nibForFile().instantiate(withOwner: nil, options: nil).first
            as! Self
    }

}


class ALUtility {
    static let userDefault = UserDefaults.standard

    class func isSaveLoginUser(_ isUserLogin: Bool) {
        userDefault.set(isUserLogin, forKey: "isUserLogin")
    }
    
    class func getSaveLogin() -> Bool {
        userDefault.bool(forKey: "isUserLogin")
    }
}




class BottomSheetPresentationController: UIPresentationController {

    private let dimmingView = UIView()

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)

        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        dimmingView.addGestureRecognizer(tap)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        let height = containerView.bounds.height * 0.45
        return CGRect(
            x: 0,
            y: containerView.bounds.height - height,
            width: containerView.bounds.width,
            height: height
        )
    }

    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }

    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true)
    }
}
