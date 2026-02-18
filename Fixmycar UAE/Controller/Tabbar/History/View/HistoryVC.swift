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
    @IBOutlet weak var viewNoHisotryFound: UIView!
    
    var historyBookingVM = HistoryBookingVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as! RecentBookingTVCell
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
