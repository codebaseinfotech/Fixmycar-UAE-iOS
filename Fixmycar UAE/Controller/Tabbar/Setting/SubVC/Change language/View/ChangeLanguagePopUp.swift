//
//  ChangeLanguagePopUp.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/01/26.
//

import UIKit

class ChangeLanguagePopUp: UIViewController {

    @IBOutlet weak var imgEnglishCheckBox: UIImageView!
    @IBOutlet weak var imgArabicCheckBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectEnglish()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedEnglish(_ sender: Any) {
        selectEnglish()
    }
    
    @IBAction func tappedArabic(_ sender: Any) {
        selectArabic()
    }
    
    func selectEnglish() {
        imgEnglishCheckBox.image = UIImage(named: "ic_check")
        imgArabicCheckBox.image = UIImage(named: "ic_uncheck")
    }
    
    func selectArabic() {
        imgEnglishCheckBox.image = UIImage(named: "ic_uncheck")
        imgArabicCheckBox.image = UIImage(named: "ic_check")
    }
}
