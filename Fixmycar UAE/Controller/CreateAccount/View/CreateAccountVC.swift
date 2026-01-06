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
            let attributedStringtxtAddressName = NSMutableAttributedString(string: lblTitleFullName.text ?? "")
            let lastCharacterIndextxtAddressName = attributedStringtxtAddressName.length - 1
            let otherCharactersRangetxtAddressName = NSRange(location: 0, length: lastCharacterIndextxtAddressName)
            attributedStringtxtAddressName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1), range: NSRange(location: lastCharacterIndextxtAddressName, length: 1))
            attributedStringtxtAddressName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1), range: otherCharactersRangetxtAddressName)
            let fullRangeAddress = NSRange(location: 0, length: attributedStringtxtAddressName.length)
            attributedStringtxtAddressName.addAttribute(.font, value: UIFont.AppFont.bold(14), range: fullRangeAddress)

            lblTitleFullName.attributedText = attributedStringtxtAddressName
        }
    }
    @IBOutlet weak var txtFullName: AppTextField!
    @IBOutlet weak var lblTitleMobileNumber: AppLabel! {
        didSet {
            let attributedStringtxtAddressName = NSMutableAttributedString(string: lblTitleMobileNumber.text ?? "")
            let lastCharacterIndextxtAddressName = attributedStringtxtAddressName.length - 1
            let otherCharactersRangetxtAddressName = NSRange(location: 0, length: lastCharacterIndextxtAddressName)
            attributedStringtxtAddressName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1), range: NSRange(location: lastCharacterIndextxtAddressName, length: 1))
            attributedStringtxtAddressName.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1), range: otherCharactersRangetxtAddressName)
            let fullRangeAddress = NSRange(location: 0, length: attributedStringtxtAddressName.length)
            attributedStringtxtAddressName.addAttribute(.font, value: UIFont.AppFont.bold(14), range: fullRangeAddress)

            lblTitleMobileNumber.attributedText = attributedStringtxtAddressName
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
