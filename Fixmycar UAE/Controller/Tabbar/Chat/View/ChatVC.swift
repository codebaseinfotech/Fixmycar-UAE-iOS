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
    @IBOutlet weak var viewNoChatFound: UIView! {
        didSet {
            tblViewList.isHidden = true
            viewNoChatFound.isHidden = false
        }
    }
    
    var chatVM = ChatVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        chatVM.getChatList()
        chatVM.successChatList = {
            
            if self.chatVM.chatList.count > 0 {
                self.viewNoChatFound.isHidden = true
                self.tblViewList.isHidden = false
            } else {
                self.viewNoChatFound.isHidden = true
                self.tblViewList.isHidden = true
            }
            
            self.tblViewList.reloadData()
        }
        chatVM.failureChatList = { msg in
            self.setUpMakeToast(msg: msg)
        }
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedTHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTSettings(_ sender: Any) {
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    

}

// MARK: - TV Delegate & DataSource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatVM.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVCell.identifier) as! ChatListTVCell
        
        let dicData = chatVM.chatList[indexPath.row]
        cell.lblName.text = dicData.chatPartner ?? ""
        cell.imgProfile.loadFromUrlString(dicData.chatPartner ?? "", placeholder: "ic_placeholder_user".image)
        cell.lblMsg.text = dicData.lastMessage ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserChatVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
