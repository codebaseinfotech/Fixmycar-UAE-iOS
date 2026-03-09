//
//  HistoryVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
//

import UIKit

class HistoryVC: UIViewController {

    // MARK: - Chat Badge Outlet (Connect this outlet to your Chat tab view in Interface Builder)
    @IBOutlet weak var viewTChatMain: UIView!

    @IBOutlet weak var tblViewBookingList: UITableView! {
        didSet {
            tblViewBookingList.register(RecentBookingTVCell.nib, forCellReuseIdentifier: RecentBookingTVCell.identifier)
            tblViewBookingList.delegate = self
            tblViewBookingList.dataSource = self
            
            tblViewBookingList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
            tblViewBookingList.showsHorizontalScrollIndicator = false
            tblViewBookingList.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var viewNoHisotryFound: UIView!

    var historyBookingVM = HistoryBookingVM()
    var chatVM = ChatVM()
    private var lblChatBadge: UILabel?
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Chat badge observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateChatBadge(_:)),
            name: .chatUnreadCountUpdated,
            object: nil
        )
        setupChatBadge()
        chatVM.getChatList()

        // Do any additional setup after loading the view.
    }

    // MARK: - Chat Badge
    private func setupChatBadge() {
        // Try outlet first, otherwise find chat button programmatically
        var chatView: UIView? = viewTChatMain

        if chatView == nil {
            chatView = findChatButtonParentView()
        }

        guard let targetView = chatView else { return }

        let badge = UILabel()
        badge.backgroundColor = UIColor(named: "primary_red") ?? .red
        badge.textColor = .white
        badge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 9
        badge.layer.masksToBounds = true
        badge.isHidden = true
        badge.translatesAutoresizingMaskIntoConstraints = false

        targetView.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.topAnchor.constraint(equalTo: targetView.topAnchor, constant: 4),
            badge.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -10),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            badge.heightAnchor.constraint(equalToConstant: 18)
        ])
        lblChatBadge = badge
    }

    private func findChatButtonParentView() -> UIView? {
        return findButtonParentView(in: view, action: #selector(tappedTChat(_:)))
    }

    private func findButtonParentView(in view: UIView, action: Selector) -> UIView? {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                if let actions = button.actions(forTarget: self, forControlEvent: .touchUpInside) {
                    if actions.contains(NSStringFromSelector(action)) {
                        return button.superview
                    }
                }
            }
            if let found = findButtonParentView(in: subview, action: action) {
                return found
            }
        }
        return nil
    }

    @objc private func updateChatBadge(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        DispatchQueue.main.async {
            if count > 0 {
                self.lblChatBadge?.text = count > 99 ? "99+" : "\(count)"
                self.lblChatBadge?.isHidden = false
            } else {
                self.lblChatBadge?.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        historyBookingVM.getHistoryBookingData()
        
        historyBookingVM.successHistoryData = {
            
            if self.historyBookingVM.historyBookingList.count == 0 {
                self.tblViewBookingList.isHidden = true
                self.viewNoHisotryFound.isHidden = false
            } else {
                self.tblViewBookingList.isHidden = false
                self.viewNoHisotryFound.isHidden = true
            }
            
            self.tblViewBookingList.reloadData()
        }
        historyBookingVM.failureHistoryData = { msg in
            self.setUpMakeToast(msg: msg)
            
            if self.historyBookingVM.historyBookingList.count == 0 {
                self.tblViewBookingList.isHidden = true
                self.viewNoHisotryFound.isHidden = false
            } else {
                self.tblViewBookingList.isHidden = false
                self.viewNoHisotryFound.isHidden = true
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedTHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTChat(_ sender: Any) {
        let vc = ChatVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedSettings(_ sender: Any) {
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

// MARK: - tv Delegate & DataSource
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyBookingVM.historyBookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as? RecentBookingTVCell else {
            return UITableViewCell()
        }
        cell.viewRecentBooking.config(type: "history_booking")

        let dicData = historyBookingVM.historyBookingList[indexPath.row]
        cell.historyBooking = dicData

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = historyBookingVM.historyBookingList[indexPath.row]

        let vc = BookingDetailsVC()
        vc.bookingVM.bookingid = dicData.bookingID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
