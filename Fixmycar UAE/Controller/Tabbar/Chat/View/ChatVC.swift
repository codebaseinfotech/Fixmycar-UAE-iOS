//
//  ChatVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblViewList: UITableView! {
        didSet {
            tblViewList.register(ChatListTVCell.nib, forCellReuseIdentifier: ChatListTVCell.identifier)
            tblViewList.delegate = self
            tblViewList.dataSource = self
        }
    }
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedTHome(_ sender: Any) {
        let vc = HomeVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTTrackLive(_ sender: Any) {
    }
    @IBAction func tappedTSetting(_ sender: Any) {
    }
    

}

// MARK: - TV Delegate & DataSource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVCell.identifier) as! ChatListTVCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserChatVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
