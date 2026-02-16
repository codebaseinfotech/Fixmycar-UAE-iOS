//
//  FeedbackVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var textViewMessage: UITextView!
    
    let viewModel = FeedbackVM()
    let messagePlaceholder = "Enter your message / complain"

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextViewPlaceholder()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSubmit(_ sender: Any) {
        guard let fullName = txtFullName.text, !fullName.isEmpty else {
            self.setUpMakeToast(msg: "Please enter fullname")
            return
        }
        guard let email = txtMobile.text, !email.isEmpty else {
            self.setUpMakeToast(msg: "Please enter email or mobile number")
            return
        }
        guard let message = textViewMessage.text, !message.isEmpty else {
            self.setUpMakeToast(msg: "Please enter message")
            return
        }
        
        viewModel.successFeedback = { msg in
            self.setUpMakeToast(msg: msg)
            self.tappedBack(self)
        }
        viewModel.failuerFeedback = { error in
            self.setUpMakeToast(msg: error)
            print("❌ Error:", error)
        }
        viewModel.submitFeedback(
            fullName: fullName,
            email: email,
            subject: "General Feedback",
            message: message
        )
    }
    
}

// MARK: - textView Delegate
extension FeedbackVC: UITextViewDelegate {
    func setupTextViewPlaceholder() {
        textViewMessage.delegate = self
        textViewMessage.text = messagePlaceholder
        textViewMessage.textColor = .lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = messagePlaceholder
            textView.textColor = .lightGray
        }
    }
}
