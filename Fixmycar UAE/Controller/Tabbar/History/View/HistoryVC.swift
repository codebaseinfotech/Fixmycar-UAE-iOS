//
//  HistoryVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class HistoryVC: UIViewController {

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
    @IBAction func tappedTrackLive(_ sender: Any) {
        let vc = TrackLiveVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTChat(_ sender: Any) {
        let vc = ChatVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTSettings(_ sender: Any) {
        let vc = SettingVC()
        navigationController?.pushViewController(vc, animated: false)
    }

    
}

// MARK: - tv Delegate & DataSource
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as! RecentBookingTVCell
        cell.viewRecentBooking.config(type: "history_booking")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookingDetailsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
