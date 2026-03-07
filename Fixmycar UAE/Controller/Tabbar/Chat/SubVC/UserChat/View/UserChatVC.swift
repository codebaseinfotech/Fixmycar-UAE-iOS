//
//  UserChatVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
//

import UIKit
import IQKeyboardManagerSwift

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
    @IBOutlet weak var viewBottomChat: UIStackView!
    
    var chatDetailsVM = ChatDetailsVM()
    
    var profileImg: String?
    var profileName: String?
    var jobStatus = ""
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if jobStatus == "rejected" || jobStatus == "cancelled" || jobStatus == "completed" {
            self.viewBottomChat.isHidden = true
        } else {
            self.viewBottomChat.isHidden = false
        }

        imgProfile.loadFromUrlString(profileImg, placeholder: "ic_placeholder_user".image)
        lblName.text = profileName

        setupBindings()
        setupSocketListeners()
        chatDetailsVM.getChatDetails()

        // Tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tblVIewList.addGestureRecognizer(tapGesture)

        // Connect socket and join room
        connectSocket()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Disable IQKeyboardManager for this screen
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Re-enable IQKeyboardManager for other screens
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        // Leave socket room
        if let bookingId = chatDetailsVM.bookingId {
            FMSocketManager.shared.leaveRoom(bookingId: bookingId)
        }
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

                self.chatDetailsVM.chatReedMessage()
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
        chatDetailsVM.successSendMessage = { [weak self] in
            self?.txtMessage.text = ""
            // Always refresh to get the sent message with correct is_me flag
            self?.chatDetailsVM.getChatDetails()
        }
        chatDetailsVM.failureSendMessage = { msg in
            self.setUpMakeToast(msg: msg)
        }
    }

    // MARK: - Socket Setup
    private func connectSocket() {
        if !FMSocketManager.shared.isConnected {
            FMSocketManager.shared.connect()
        } else {
            // Already connected, join room directly
            if let bookingId = chatDetailsVM.bookingId {
                FMSocketManager.shared.joinRoom(bookingId: bookingId)
            }
        }
    }

    private func setupSocketListeners() {
        // On socket connected
        FMSocketManager.shared.onConnect = { [weak self] in
            guard let self = self, let bookingId = self.chatDetailsVM.bookingId else { return }
            FMSocketManager.shared.joinRoom(bookingId: bookingId)
        }

        // On message received - Only show messages from OTHER users (not our own)
        FMSocketManager.shared.onMessageReceived = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // Skip if it's our own message (is_me == true) - we already show it via API refresh
                if message.is_me == true {
                    debugPrint("[SOCKET] Skipping own message echo")
                    return
                }
                
                self.chatDetailsVM.getChatDetails()

//                // Avoid duplicates
//                if !self.chatDetailsVM.messageList.contains(where: { $0.id == message.id }) {
//                    self.chatDetailsVM.messageList.append(message)
//                    self.tblVIewList.reloadData()
//                    self.scrollToBottom(animated: true)
//                }
            }
        }

        // On error
        FMSocketManager.shared.onError = { [weak self] error in
            debugPrint("Socket error: \(error)")
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
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        // Calculate how much to move up
        let keyboardTop = view.frame.height - keyboardFrame.height
        let bottomChatBottom = viewBottomChat.frame.maxY
        let overlap = bottomChatBottom - keyboardTop + 15 // 15 points padding

        guard overlap > 0 else { return }

        UIView.animate(withDuration: duration) {
            self.viewBottomChat.transform = CGAffineTransform(translationX: 0, y: -overlap)
            // Adjust tableView content inset instead of transform
            self.tblVIewList.contentInset.bottom = overlap
            self.tblVIewList.verticalScrollIndicatorInsets.bottom = overlap
            self.view.layoutIfNeeded()
        }

        scrollToBottom(animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: duration) {
            self.viewBottomChat.transform = .identity
            self.tblVIewList.contentInset.bottom = 0
            self.tblVIewList.verticalScrollIndicatorInsets.bottom = 0
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedVoice(_ sender: Any) {
    }
    @IBAction func tappedSend(_ sender: Any) {
        guard let message = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else { return }

        debugPrint("[CHAT] tappedSend called")
        debugPrint("[CHAT] Message: \(message)")
        debugPrint("[CHAT] booking ID: \(chatDetailsVM.bookingId ?? -1)")
        debugPrint("[CHAT] Socket Connected: \(FMSocketManager.shared.isConnected)")

        chatDetailsVM.message = message

        // Send via socket for real-time
        if let bookingId = chatDetailsVM.bookingId {
            debugPrint("[CHAT] Calling socket sendMessage...")
            FMSocketManager.shared.sendMessage(bookingId: bookingId, message: message)
        } else {
            debugPrint("[CHAT] ERROR: bookingId is nil!")
        }

        // Also send via API for persistence
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatTVCell.identifier) as? SenderChatTVCell else {
                return UITableViewCell()
            }
            cell.chatDetails = dicData
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReciverChatTVCell.identifier) as? ReciverChatTVCell else {
                return UITableViewCell()
            }
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
