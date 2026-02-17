//
//  DeleteAccountVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class DeleteAccountVC: UIViewController {

    @IBOutlet weak var tblViewReasonList: UITableView!
    
    @IBOutlet weak var heightConstTblView: NSLayoutConstraint!
    
    var arrReasonList = ["I am no longer need this service", "I found a better alternative", "I’m facing technical issues", "Privacy concerns", "I don’t understand how to use", "Other issue"]
    
    var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewReasonList.register(UINib(nibName: "ReasonListTblViewCell", bundle: nil), forCellReuseIdentifier: "ReasonListTblViewCell")
        tblViewReasonList.dataSource = self
        tblViewReasonList.delegate = self
        
        tblViewReasonList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                self.heightConstTblView.constant = newsize.height
            }
        }
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDeleteAcc(_ sender: Any) {
        let vc = LogoutPopUp()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 330
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        vc.isOpenLogout = false
        vc.viewModel.selectedDeleteReason = arrReasonList[self.selectedIndex ?? 0]
        self.present(vc, animated: true)
    }
    
}

extension DeleteAccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReasonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewReasonList.dequeueReusableCell(withIdentifier: "ReasonListTblViewCell") as! ReasonListTblViewCell
        
        cell.lblReason.text = arrReasonList[indexPath.row]
        
        cell.lblBottomLine.isHidden = (indexPath.row == arrReasonList.count - 1)
        
        if selectedIndex == indexPath.row {
            cell.imgCheckBox.image = UIImage(named: "ic_check")
        } else {
            cell.imgCheckBox.image = UIImage(named: "ic_uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
}

// MARK: - UISheetPresentationControllerDelegate
extension DeleteAccountVC: UISheetPresentationControllerDelegate {
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
