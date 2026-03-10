//
//  ChatVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblViewList: UITableView! {
        didSet {
            tblViewList.register(ChatListTVCell.nib, forCellReuseIdentifier: ChatListTVCell.identifier)
            tblViewList.delegate = self
            tblViewList.dataSource = self
            tblViewList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
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

        chatVM.successChatList = { [weak self] in
            guard let self = self else { return }
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
        chatVM.failureChatList = { [weak self] msg in
            self?.setUpMakeToast(msg: msg)
        }

        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        // Listen for real-time socket messages
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSocketMessage(_:)),
            name: .socketMessageReceived,
            object: nil
        )

        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        tblViewList.refreshControl = refreshControl

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        chatVM.getChatList()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Real-time Socket Message Handler
    @objc private func handleSocketMessage(_ notification: Notification) {
        guard let message = notification.userInfo?["message"] as? MessageDetails else { return }

        // Skip own messages
        if message.is_me == true { return }

        // Refresh chat list when new message arrives
        DispatchQueue.main.async {
            self.chatVM.getChatList()
        }
    }

    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        chatVM.getChatList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.endRefreshing()
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVCell.identifier) as? ChatListTVCell else {
            return UITableViewCell()
        }

        let dicData = filteredChatList[indexPath.row]
        cell.chatListData = dicData

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = filteredChatList[indexPath.row]
        
        let vc = UserChatVC()
        vc.jobStatus = dicData.jobStatus ?? ""
        vc.chatDetailsVM.bookingId = dicData.bookingId ?? 0
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
