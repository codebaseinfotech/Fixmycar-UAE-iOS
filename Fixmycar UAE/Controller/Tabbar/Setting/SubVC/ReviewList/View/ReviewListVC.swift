//
//  ReviewListVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 06/03/26.
//

import UIKit

class ReviewListVC: UIViewController {

    @IBOutlet weak var tblView: UITableView! {
        didSet {
            tblView.delegate = self
            tblView.dataSource = self
            tblView.register(ReviewListTVCell.nib, forCellReuseIdentifier: ReviewListTVCell.identifier)
            tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
    }
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var reviewVM = ReviewVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewVM.getReviewList()
        reviewVM.successReviewList = {
            self.viewNoDataFound.isHidden = self.reviewVM.reviewList.count > 0 ? true : false
            self.scrollView.isHidden = self.reviewVM.reviewList.count > 0 ? false : true
            self.tblView.reloadData()
        }
        reviewVM.failureReviewList = { msg in
            self.setUpMakeToast(msg: msg)
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newsize = change?[.newKey] as? CGSize {
                self.heightTblView.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

// MARK: - tblView Delegate & DataSource
extension ReviewListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewVM.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewListTVCell.identifier) as? ReviewListTVCell else {
            return UITableViewCell()
        }
        
        let dicData = reviewVM.reviewList[indexPath.row]
        cell.imgPic.loadFromUrlString(dicData.driver?.profilePhoto ?? "")
        cell.lblName.text = dicData.driver?.fullName
        cell.viewRating.value = CGFloat(dicData.rating ?? 0)
        cell.lblDescription.text = dicData.review
        cell.lblTime.text = dicData.createdAt?.timeAgo() ?? ""
        cell.lblRating.text = "\(dicData.rating ?? 0)"
        
        return cell
    }
    
}
