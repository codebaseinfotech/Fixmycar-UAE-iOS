//
//  RecoveryServiceVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 23/01/26.
//

import UIKit

class RecoveryServiceVC: UIViewController {

    @IBOutlet weak var lblBookService: AppLabel!
    @IBOutlet weak var lblLineBookService: UILabel!
    @IBOutlet weak var lblScheduleLater: AppLabel!
    @IBOutlet weak var lblLineScheduleLater: UILabel!
    @IBOutlet weak var heightConstBookServiceLine: NSLayoutConstraint!
    @IBOutlet weak var heightConstScheduleLaterLine: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectBookService()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedBookServiceNow(_ sender: Any) {
        selectBookService()
    }
    
    @IBAction func tappedScheduleForLater(_ sender: Any) {
        selectScheduleLater()
    }
    
    func selectBookService() {
        heightConstBookServiceLine.constant = 2
        heightConstScheduleLaterLine.constant = 1
        
        lblBookService.textColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        lblScheduleLater.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        
        lblBookService.font = UIFont.AppFont.bold(14)
        lblScheduleLater.font = UIFont.AppFont.medium(14)
        
        lblLineBookService.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        lblLineScheduleLater.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    }
    
    func selectScheduleLater() {
        heightConstBookServiceLine.constant = 1
        heightConstScheduleLaterLine.constant = 2
        
        lblBookService.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        lblScheduleLater.textColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        
        lblBookService.font = UIFont.AppFont.medium(14)
        lblScheduleLater.font = UIFont.AppFont.bold(14)
        
        lblLineBookService.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        lblLineScheduleLater.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
    }
    
    
    
}
