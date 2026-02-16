//
//  LoginVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 01/01/26.
//

import UIKit

class LoginVC: UIViewController {


    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField! {
        didSet {
            mobileNumberTextField.maxLength = 10
        }
    }
    @IBOutlet weak var byContinueLabel: UILabel!
    
    var viewModel = LoginVM()
    var verifyOtpVM = VerifyOtpVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitleLabel()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Bind VM
    func bindViewModel() {
        viewModel.successLogin = {
            DispatchQueue.main.async {
                self.presentOtp()
            }
        }
        
        viewModel.failureLogin = { [weak self] message in
            DispatchQueue.main.async {
                self?.setUpMakeToast(msg: message)
            }
        }
    }
    
    func presentOtp() {
        let vc = VerifyOtp()
        vc.modalPresentationStyle = .custom
        vc.delegateVerify = self
        
        // ✅ Pass DATA not outlet
        vc.viewModel.phoneNumber = self.viewModel.loginResponse?.data?.phone ?? ""
        vc.otpDebug = "\(self.viewModel.loginResponse?.data?.otpDebug ?? 0)"
        self.present(vc, animated: true)
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
            string: "Fixmycar UAE",
            attributes: [
                .font: UIFont.AppFont.black(30),
                .foregroundColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            ]
        ))
        
        welcomeTitleLabel.attributedText = text
    }
    
    // MARK: - Action Method
    @IBAction func tappedContinue(_ sender: Any) {
        guard let phone = mobileNumberTextField.text, !phone.isEmpty else {
            setUpMakeToast(msg: "Please enter mobile number")
            return
        }
        
        if phone.count < 10 {
            setUpMakeToast(msg: "Please enter valid mobile number")
            return
        }
        
        viewModel.callLoginAPI(phone: phone, countryCode: "+971")
    }
    @IBAction func tappedTC(_ sender: Any) {
        let vc = LegalInfoVC()
        vc.screen = .termsAndConditions
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedPP(_ sender: Any) {
        let vc = LegalInfoVC()
        vc.screen = .privacyPolicy
        navigationController?.pushViewController(vc, animated: true)
    }
    
     

}
// MARK: - didTapOnVerify
extension LoginVC: didTapOnVerify {
    func onCallTappedVerify(enteredOtp: String, phoneNumber: String) {
        
        verifyOtpVM.callVerifyOtpAPI(
            phone: phoneNumber,
            otp: enteredOtp,
            countryCode: "+971"
        )
        
        verifyOtpVM.successVerify = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let isRegistered = self.verifyOtpVM.verifyResponse?.isRegistered ?? false
                
                print("IS REGISTERED =", isRegistered)

                if isRegistered {
                    AppDelegate.appDelegate.setUpHome()
                } else {
                    let vc = CreateAccountVC()
                    vc.phoneNumber = phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        verifyOtpVM.failureVerify = { [weak self] message in
            DispatchQueue.main.async {
                self?.setUpMakeToast(msg: message)

                if message == "Invalid OTP." {
                    DispatchQueue.main.async {
                        self?.presentOtp()
                    }
                } else {
                    let vc = CreateAccountVC()
                    vc.phoneNumber = phoneNumber
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
