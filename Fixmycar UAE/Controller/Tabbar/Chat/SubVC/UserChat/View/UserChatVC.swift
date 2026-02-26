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
            
            tblVIewList.separatorStyle = .none
            tblVIewList.showsVerticalScrollIndicator = false
            tblVIewList.rowHeight = UITableView.automaticDimension
            tblVIewList.estimatedRowHeight = 60

        }
    }
    @IBOutlet weak var txtMessage: UITextField! {
        didSet {
            txtMessage.returnKeyType = .send
            txtMessage.delegate = self
        }
    }
    
    var chatDetailsVM = ChatDetailsVM()
    
    var profileImg: String?
    var profileName: String?
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.loadFromUrlString(profileImg, placeholder: "ic_placeholder_user".image)
        lblName.text = profileName
        
        setupBindings()
        chatDetailsVM.getChatDetails()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if chatDetailsVM.messageList.count > 0 {
            scrollToBottom(animated: false)
        }
    }
    
    // MARK: - Bind ViewModel
    private func setupBindings() {
        
        // ChatList
        chatDetailsVM.successChatDetails = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                // Sort Old → New
                self.chatDetailsVM.messageList.sort {
                    $0.created_at?.toDate() ?? Date() <
                        $1.created_at?.toDate() ?? Date()
                }
                
                self.tblVIewList.reloadData()
                
                // Important Fix
                self.tblVIewList.layoutIfNeeded()
                self.scrollToBottom(animated: false)
            }
        }
        
        chatDetailsVM.failureChatDetails = { [weak self] msg in
            DispatchQueue.main.async {
                self?.setUpMakeToast(msg: msg)
            }
        }
        
        // Send Message
        chatDetailsVM.successSendMessage = {
            self.txtMessage.text = ""
            self.chatDetailsVM.getChatDetails()
        }
        chatDetailsVM.failureSendMessage = { msg in
            self.setUpMakeToast(msg: msg)
        }
    }
    
    // MARK: - Scroll
    private func scrollToBottom(animated: Bool = true) {
        
        let count = chatDetailsVM.messageList.count
        guard count > 0 else { return }
        
        let indexPath = IndexPath(row: count - 1, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.tblVIewList.scrollToRow(at: indexPath,
                                         at: .bottom,
                                         animated: animated)
        }
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedVoice(_ sender: Any) {
    }
    @IBAction func tappedSend(_ sender: Any) {
        guard let message = txtMessage.text, !message.isEmpty else { return }
        chatDetailsVM.message = message
        
        chatDetailsVM.sendMessageOnChat()
    }
    

    
}

extension UserChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDetailsVM.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dicData = chatDetailsVM.messageList[indexPath.row]
        
        if dicData.is_me == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatTVCell.identifier) as! SenderChatTVCell
            
            cell.chatDetails = dicData
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReciverChatTVCell.identifier) as! ReciverChatTVCell
            
            cell.chatDetails = dicData
            
            return cell
        }        
    }
    
    
}

// MARK: - textFiled Deletegate
extension UserChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !text.isEmpty {
            chatDetailsVM.message = text
            chatDetailsVM.sendMessageOnChat()
        }
        
        textField.resignFirstResponder()
        return true
    }
}
