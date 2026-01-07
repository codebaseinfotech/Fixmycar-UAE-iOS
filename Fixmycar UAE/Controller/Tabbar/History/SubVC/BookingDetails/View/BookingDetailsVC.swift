//
//  BookingDetailsVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class BookingDetailsVC: UIViewController {

    @IBOutlet weak var lblInvoiceName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
