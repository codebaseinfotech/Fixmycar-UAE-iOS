//
//  AddRateVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 06/03/26.
//

import UIKit

class AddRateVC: UIViewController {

    @IBOutlet weak var rateView: HCSStarRatingView! {
        didSet {
            rateView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var txtRateVie: UITextView!
    
    var tappedSubmit: (() -> Void)?
    var addRateVM = AddRateVM()
    
    var valueRate: Double = 0.0
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bookingIDReview: ", addRateVM.notificationPayload?.bookingId ?? 0)
        
        txtRateVie.delegate = self
        txtRateVie.isScrollEnabled = false

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Method
    @IBAction func tappedRate(_ sender: HCSStarRatingView) {
        valueRate = sender.value
    }
    @IBAction func tappedSubmit(_ sender: Any) {
        guard valueRate != 0.0 else {
            self.setUpMakeToast(msg: "Please select star rating")
            return
        }
        
        guard let massgae = txtRateVie.text, !massgae.isEmpty else {
            self.setUpMakeToast(msg: "Please enter your feedback")
            return
        }
        
        addRateVM.rating = Int(valueRate)
        addRateVM.review = massgae
        
        addRateVM.addRate()
        addRateVM.successRate = {
            self.dismiss(animated: false) {
                self.tappedSubmit?()
            }
        }
        addRateVM.failureRate = { (error) in
            self.setUpMakeToast(msg: error)
        }
        
    }
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: false)
    }
    

}

// MARK: - textView Delegate
extension AddRateVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = true
    }
}
