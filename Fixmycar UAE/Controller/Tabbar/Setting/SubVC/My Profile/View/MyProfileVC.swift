//
//  MyProfileVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtNumber: AppTextField!
    @IBOutlet weak var txtEmail: AppTextField!
    
    @IBOutlet weak var lblTFullName: UILabel! {
        didSet {
            let fullText = "Full name *".localized

            lblTFullName.attributedText = fullText.attributedText(
                defaultFont: UIFont.AppFont.bold(14),
                defaultColor: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1),
                highlightText: "*",
                highlightColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            )
        }
    }
    @IBOutlet weak var lblTMobileNumber: UILabel! {
        didSet {
            let fullText = "Mobile number *".localized

            lblTMobileNumber.attributedText = fullText.attributedText(
                defaultFont: UIFont.AppFont.bold(14),
                defaultColor: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1),
                highlightText: "*",
                highlightColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            )
        }
    }
    
    var profileVM = MyProfileVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileVM.getProfile()
        
        profileVM.successGetProfile = {
            self.lblUserName.text = FCUtilites.getCurrentUser()?.name ?? ""
            self.txtFullName.text = FCUtilites.getCurrentUser()?.firstName ?? ""
            self.txtNumber.text = FCUtilites.getCurrentUser()?.phone ?? ""
            self.txtEmail.text = FCUtilites.getCurrentUser()?.email ?? ""
            
            self.imgProfile.loadFromUrlString(FCUtilites.getCurrentUser()?.avatar ?? "", placeholder: "ic_placeholder_user".image)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let joinedAt = FCUtilites.getCurrentUser()?.joinedAt ?? ""
        let result = formattedMemberSince(from: joinedAt)
        lblDate.text = result
        lblUserName.text = FCUtilites.getCurrentUser()?.name ?? ""
        txtFullName.text = FCUtilites.getCurrentUser()?.firstName ?? ""
        txtNumber.text = FCUtilites.getCurrentUser()?.phone ?? ""
        txtEmail.text = FCUtilites.getCurrentUser()?.email ?? ""
        
        imgProfile.loadFromUrlString(FCUtilites.getCurrentUser()?.avatar ?? "", placeholder: "ic_placeholder_user".image)
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEditProfile(_ sender: Any) {
        let vc = EditProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - setUp Join Date
    func formattedMemberSince(from dateString: String) -> String {
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)
        
        return "Member since \(day)\(daySuffix(day)) \(month), \(year)"
    }

    func daySuffix(_ day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }

}
