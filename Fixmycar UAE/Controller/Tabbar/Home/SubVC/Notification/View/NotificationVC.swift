//
//  NotificationVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 23/01/26.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tblViewNotificationList: UITableView! {
        didSet {
            tblViewNotificationList.register(NotifivationTblViewCell.nib, forCellReuseIdentifier: NotifivationTblViewCell.identifier)
            tblViewNotificationList.register(NotificationHeaderView.nib, forHeaderFooterViewReuseIdentifier: NotificationHeaderView.identifier)
            tblViewNotificationList.dataSource = self
            tblViewNotificationList.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewNotificationList.sectionHeaderTopPadding = 0
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewNotificationList.dequeueReusableCell(withIdentifier: "NotifivationTblViewCell") as! NotifivationTblViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NotificationHeaderView.identifier
        ) as! NotificationHeaderView

        if section == 0 {
            header.lblDuration.text = "Today"
        } else {
            header.lblDuration.text = "Yesterday"
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
}
