//
//  LoginVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 01/01/26.
//

import UIKit

class LoginVC: UIViewController {


    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var byContinueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitleLabel()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setUpTitle
    func setUpTitleLabel() {
        let text = NSMutableAttributedString(
            string: "Welcome to\n",
            attributes: [
                .font: UIFont.AppFont.black(30),
                .foregroundColor: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
            ]
        )
        
        text.append(NSAttributedString(
            string: "Toretto Auto Care",
            attributes: [
                .font: UIFont.AppFont.black(30),
                .foregroundColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            ]
        ))
        
        welcomeTitleLabel.attributedText = text
        
        let fullText = "By continuing, you agree to our Terms of Service & Privacy Policy"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.AppFont.medium(14),
                .foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            ]
        )

        // Highlight text
        let highlightText = "Terms of Service & Privacy Policy"
        let range = (fullText as NSString).range(of: highlightText)

        attributedText.addAttributes([
            .foregroundColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: range)

        byContinueLabel.attributedText = attributedText
    }
    
    // MARK: - Action Method
    @IBAction func tappedContinue(_ sender: Any) {
        let vc = VerifyOtp()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.delegateVerify = self
        self.present(vc, animated: true)
    }
    
     

}
// MARK: - didTapOnVerify
extension LoginVC: didTapOnVerify {
    func onCallTappedVerify() {
        let vc = CreateAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// MARK: - viewControllerDelegate
extension LoginVC: UIViewControllerTransitioningDelegate {
    func presentationController(
           forPresented presented: UIViewController,
           presenting: UIViewController?,
           source: UIViewController
       ) -> UIPresentationController? {
           return BottomSheetPresentationController(
               presentedViewController: presented,
               presenting: presenting
           )
       }
}
