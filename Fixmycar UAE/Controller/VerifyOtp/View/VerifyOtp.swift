//
//  VerifyOtp.swift
//  Fixmycar UAE
//
//  Created by Ankit on 01/01/26.
//

import UIKit

protocol didTapOnVerify: AnyObject {
    func onCallTappedVerify(enteredOtp: String, phoneNumber: String)
}

class VerifyOtp: UIViewController {
    
    @IBOutlet weak var viewMain: UIView! {
        didSet {
            viewMain.clipsToBounds = true
            viewMain.layer.cornerRadius = 20
            viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top Corner
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var otpFieldView: OTPFieldView!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnResend: AppButton! {
        didSet {
            let resendText = "Resend code"

            let attributedString = NSMutableAttributedString(string: resendText)

            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1),
                .font: UIFont.AppFont.medium(14)
            ], range: NSRange(location: 0, length: resendText.count))

            btnResend.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    var delegateVerify: didTapOnVerify?
    
    var viewModel = VerifyOtpVM()
    var loginVM = LoginVM()
    
    var otpDebug: String?
    
    var enteredOtp: String = ""
    
    var timer: Timer?
    var totalSeconds = 59
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupOtpView()
        startTimer()
        
        viewMain.isHidden = false
        viewMain.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        UIView.animate(
            withDuration: 0.25,          // ⏱ slower
            delay: 0.0,
            usingSpringWithDamping: 1.0, // 🧈 smooth stop
            initialSpringVelocity: 1.0,  // 🐢 gentle start
            options: [.curveEaseOut],
            animations: {
                self.viewMain.transform = .identity
            },
            completion: { _ in
                // ✅ Called AFTER animation finishes
                self.setupOtpView()
            }
        )
//        self.setupOtpView()
        
        lblPhoneNumber.text = "+971 \(viewModel.phoneNumber)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupOtpView(){
        self.otpFieldView.fieldsCount = 6
        self.otpFieldView.fieldBorderWidth = 0
        self.otpFieldView.defaultBorderColor = UIColor.clear
        self.otpFieldView.filledBorderColor = UIColor.clear
        self.otpFieldView.defaultBackgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.otpFieldView.filledBackgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.otpFieldView.cursorColor = UIColor.black
        self.otpFieldView.displayType = .circular
        self.otpFieldView.fieldSize = 42
        self.otpFieldView.separatorSpace = 8
        self.otpFieldView.shouldAllowIntermediateEditing = false
        self.otpFieldView.delegate = self
        self.otpFieldView.initializeUI()
    }
    
    // MARK: - Action Method
    @IBAction func tappedResendCode(_ sender: Any) {
        loginVM.callLoginAPI(phone: viewModel.phoneNumber, countryCode: "+971")
        loginVM.successLogin = {
            self.startTimer()
        }
    }
    @IBAction func tappedVerifu(_ sender: Any) {
        
        guard enteredOtp.count == 6 else {
            setUpMakeToast(msg: "Please enter valid OTP")
            return
        }
        viewModel.callVerifyOtpAPI(phone: viewModel.phoneNumber, otp: enteredOtp, countryCode: "+971")
        
        viewModel.successVerify = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let isRegistered = self.viewModel.verifyResponse?.isRegistered ?? false
                
                debugPrint("IS REGISTERED =", isRegistered)

                if isRegistered {
                    AppDelegate.appDelegate.setUpHome()
                } else {
                    let vc = CreateAccountVC()
                    vc.phoneNumber = self.viewModel.phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        viewModel.failureVerify = { [weak self] message in
            DispatchQueue.main.async {
                self?.setUpMakeToast(msg: message)                
            }
        }
    
    }
    @IBAction func tappedClose(_ sender: Any) {
        dismissToBottom()
    }
    
    func dismissToBottom(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 1.0,   // no bounce on exit
            initialSpringVelocity: 0.3,
            options: [.curveEaseIn],
            animations: {
                self.viewMain.transform =
                CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
                self.viewMain.alpha = 0
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                    self.dismiss(animated: false)
                }
                
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    // MARK: - Show Timer
    func startTimer() {
        // Hide button while counting
        btnResend.isEnabled = false
        timeLabel.isHidden = false
        
        totalSeconds = 59
        timeLabel.text = "00:\(totalSeconds)"
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimer() {
        if totalSeconds > 0 {
            totalSeconds -= 1
            timeLabel.text = "00:\(totalSeconds)"
        } else {
            timer?.invalidate()
            timer = nil
            // Show button again
            timeLabel.isHidden = true
            btnResend.isEnabled = true
        }
    }
    
}


extension VerifyOtp: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        debugPrint("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        debugPrint("OTPString: \(otpString)")
        self.enteredOtp = otpString
    }
}
