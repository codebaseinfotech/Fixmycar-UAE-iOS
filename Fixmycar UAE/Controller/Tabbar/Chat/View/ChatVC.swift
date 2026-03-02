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
    var filteredChatList: [InboxItem] = []
    var isSearching: Bool = false
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        chatVM.getChatList()
        chatVM.successChatList = {
            self.filteredChatList = self.chatVM.chatList
            
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
        
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
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
    
    // MARK: - Search
    @objc func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""

        if searchText.isEmpty {
            isSearching = false
            filteredChatList = chatVM.chatList
        } else {
            isSearching = true
            filteredChatList = chatVM.chatList.filter { item in
                let name = item.chatPartner?.lowercased() ?? ""
                return name.contains(searchText)
            }
        }

        tblViewList.reloadData()
    }

}

// MARK: - TV Delegate & DataSource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVCell.identifier) as! ChatListTVCell
        
        let dicData = filteredChatList[indexPath.row]
        cell.chatListData = dicData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = filteredChatList[indexPath.row]
        
        let vc = UserChatVC()
        vc.chatDetailsVM.jobId = dicData.jobId ?? 0
        vc.profileImg = dicData.partnerImage ?? ""
        vc.profileName = dicData.chatPartner ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// MARK: - UITextFieldDelegate
extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
