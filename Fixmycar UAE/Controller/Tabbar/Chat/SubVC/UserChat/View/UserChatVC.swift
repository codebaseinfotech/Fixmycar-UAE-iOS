//
//  UserChatVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class UserChatVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var tblVIewList: UITableView! {
        didSet {
            tblVIewList.register(SenderChatTVCell.nib, forCellReuseIdentifier: SenderChatTVCell.identifier)
            tblVIewList.register(ReciverChatTVCell.nib, forCellReuseIdentifier: ReciverChatTVCell.identifier)
            tblVIewList.delegate = self
            tblVIewList.dataSource = self
        }
    }
    @IBOutlet weak var txtMessage: UITextField!
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedVoice(_ sender: Any) {
    }
    @IBAction func tappedSend(_ sender: Any) {
    }
    

    
}

extension UserChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatTVCell.identifier) as! SenderChatTVCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReciverChatTVCell.identifier) as! ReciverChatTVCell
            
            return cell
        }
        
    }
    
    
}
