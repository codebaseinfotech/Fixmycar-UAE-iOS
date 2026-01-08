//
//  SettingVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
    }
    
    @IBOutlet weak var switchBookingUpdate: UISwitch!
    @IBOutlet weak var switchDriverAssigned: UISwitch!
    @IBOutlet weak var switchOffers: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scaleX: CGFloat = 36.0 / 49.0
        let scaleY: CGFloat = 20.0 / 31.0
        
        switchBookingUpdate.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        switchDriverAssigned.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        switchOffers.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedTHome(_ sender: Any) {
        let vc = HomeVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func clickedTTrackLive(_ sender: Any) {
    }
    
    @IBAction func tappedTChat(_ sender: Any) {
    }
    
    @IBAction func tappedMyProfile(_ sender: Any) {
        let vc = MyProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedChangeLang(_ sender: Any) {
        let vc = ChangeLanguagePopUp()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 300
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func tappedContactSupport(_ sender: Any) {
        let vc = JumpStartVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 220
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        vc.isHomeOpen = false
        self.present(vc, animated: true)
    }
    
    @IBAction func tappedHelpAndFAQs(_ sender: Any) {
        let vc = HelpAndFAQsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedSubmitFreedback(_ sender: Any) {
        let vc = FeedbackVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        let vc = LogoutPopUp()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 320
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func tappedDeleteAccount(_ sender: Any) {
        let vc = DeleteAccountVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension SettingVC: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let overlayView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                overlayView.alpha = 0
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
            
        }
    }
}
