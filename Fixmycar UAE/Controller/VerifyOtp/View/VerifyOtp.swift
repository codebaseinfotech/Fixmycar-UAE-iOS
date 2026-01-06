//
//  VerifyOtp.swift
//  Fixmycar UAE
//
//  Created by Ankit on 01/01/26.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        
        viewMain.isHidden = false
        viewMain.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        UIView.animate(
            withDuration: 0.7,          // ⏱ slower
            delay: 0.05,
            usingSpringWithDamping: 0.88, // 🧈 smooth stop
            initialSpringVelocity: 0.4,  // 🐢 gentle start
            options: [.curveEaseOut],
            animations: {
                self.viewMain.transform = .identity
            },
            completion: nil
        )
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
        self.otpFieldView.fieldSize = 38
        self.otpFieldView.separatorSpace = 8
        self.otpFieldView.shouldAllowIntermediateEditing = false
        self.otpFieldView.delegate = self
        self.otpFieldView.initializeUI()
    }
    
    @IBAction func tappedResendCode(_ sender: Any) {
    }
    @IBAction func tappedVerifu(_ sender: Any) {
        dismissToBottom {
            
        }
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
    
}
 
extension VerifyOtp: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
    }
}
