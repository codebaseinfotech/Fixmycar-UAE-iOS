//
//  CreateAccountVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 06/01/26.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var lblTitleFullName: AppLabel! {
        didSet {
            let attributedStringFullName = NSMutableAttributedString(string: lblTitleFullName.text ?? "")
            let lastCharacterIndexFullName = attributedStringFullName.length - 1
            let otherCharactersRangeFullName = NSRange(location: 0, length: lastCharacterIndexFullName)
            attributedStringFullName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1), range: NSRange(location: lastCharacterIndexFullName, length: 1))
            attributedStringFullName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1), range: otherCharactersRangeFullName)
            let fullRangeFullName = NSRange(location: 0, length: attributedStringFullName.length)
            attributedStringFullName.addAttribute(.font, value: UIFont.AppFont.bold(14), range: fullRangeFullName)

            lblTitleFullName.attributedText = attributedStringFullName
        }
    }
    @IBOutlet weak var txtFullName: AppTextField!
    @IBOutlet weak var lblTitleMobileNumber: AppLabel! {
        didSet {
            let attributedStringMobileNumber = NSMutableAttributedString(string: lblTitleMobileNumber.text ?? "")
            let lastCharacterIndexMobileNumber = attributedStringMobileNumber.length - 1
            let otherCharactersRangeMobileNumber = NSRange(location: 0, length: lastCharacterIndexMobileNumber)
            attributedStringMobileNumber.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1), range: NSRange(location: lastCharacterIndexMobileNumber, length: 1))
            attributedStringMobileNumber.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1), range: otherCharactersRangeMobileNumber)
            let fullRangeAddress = NSRange(location: 0, length: attributedStringMobileNumber.length)
            attributedStringMobileNumber.addAttribute(.font, value: UIFont.AppFont.bold(14), range: fullRangeAddress)

            lblTitleMobileNumber.attributedText = attributedStringMobileNumber
        }
    }
    @IBOutlet weak var txtMobileNumber: AppTextField!
    @IBOutlet weak var txtEmailAddress: AppTextField!
    @IBOutlet weak var txtReferralCode: AppTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedContinue(_ sender: Any) {
    }
    
}
