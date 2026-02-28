//
//  LegalInfoVC.swift
//  Fixmycar UAE
//
//  Created by Kenil on 16/02/26.
//

import UIKit

enum LegalInfoAll: String {
    case termsAndConditions
    case privacyPolicy
    case aboutUs
}

class LegalInfoVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMessage: AppTextView!
    
    var screen: LegalInfoAll?
    var legalInfoVM = LegalInfoVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreens()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callLegalInfoAPI()
    }
    

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - setUp UI
    func setUpScreens() {
        switch screen {
        case .termsAndConditions:
            lblTitle.text = "Terms & conditions"
        case .privacyPolicy:
            lblTitle.text = "Privacy policy"
        case .aboutUs:
            lblTitle.text = "About us"
        case nil:
            break
        }
    }
    
    func callLegalInfoAPI() {
        guard let screen else { return }
        legalInfoVM.legalInfo(screen: screen)
        
        legalInfoVM.successLegalInfo = {
            self.txtMessage.setHTML(self.legalInfoVM.legalInfoData?.content ?? "")
        }
        
        legalInfoVM.failureLegalInfo = { error in
            debugPrint("❌ Legal Info Error:", error)
        }
    }
   
}
