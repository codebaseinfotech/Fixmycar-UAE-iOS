//
//  PendingJobVC.swift
//  Fixmycar UAE
//
//  Created by Kenil on 03/03/26.
//

import UIKit

class PendingJobVC: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewBottomPopup: UIView!
    @IBOutlet weak var viewLoader: FindingDriverLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
