//
//  HomeVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewDotsNotification: UIView!
    
    @IBOutlet weak var tblViewRecentBooking: UITableView! {
        didSet {
            tblViewRecentBooking.register(RecentBookingTVCell.nib, forCellReuseIdentifier: RecentBookingTVCell.identifier)
            tblViewRecentBooking.delegate = self
            tblViewRecentBooking.dataSource = self
            
            tblViewRecentBooking.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            tblViewRecentBooking.separatorStyle = .none
        }
    }
    @IBOutlet weak var heightTVRecentBooking: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                self.heightTVRecentBooking.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedApplyCode(_ sender: Any) {
    }
    @IBAction func tappedRecovery(_ sender: Any) {
    }
    @IBAction func tappedJumpStart(_ sender: Any) {
        let vc = JumpStartVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 300
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func tappedViewAllRecentBooking(_ sender: Any) {
    }
    
    // tabbar Action
    @IBAction func tappedTHistory(_ sender: Any) {
        let vc = HistoryVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTTrackLive(_ sender: Any) {
    }
    @IBAction func tappedTChat(_ sender: Any) {
        let vc = ChatVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func tappedTSetting(_ sender: Any) {
    }
    
}

// MARK: - tv Delegate & DataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentBookingTVCell.identifier) as! RecentBookingTVCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

extension HomeVC: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let overlayView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                overlayView.alpha = 0
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
            
        }
    }
}
