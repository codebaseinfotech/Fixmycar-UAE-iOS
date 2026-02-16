//
//  JumpStartVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class JumpStartVC: UIViewController {

    @IBOutlet weak var lblTitle: AppLabel!
    @IBOutlet weak var lblDis: AppLabel!
    
    var isHomeOpen: Bool = true
    
    var supportVM = JumpStartVM()

    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if isHomeOpen {
            lblTitle.text = "Jump start assistant"
            lblDis.text = "Car battery dead? Our team is available to assist you quickly and safety. Jump start service will be available for online booking soon. For immediate assistance, please contact our support team using one of the options below."
        } else {
            lblTitle.text = "Contact support"
            lblDis.text = "We’re here to assist you with bookings, live tracking and any service related queries."
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        supportVM.getSupportDetails()
    }

    // MARK: - Action Method
    @IBAction func tappedChatUs(_ sender: Any) {
        setUpUI(isOpen: isHomeOpen, title: "Chat")
    }
    @IBAction func tappedCallUs(_ sender: Any) {
        setUpUI(isOpen: isHomeOpen, title: "Call")
    }
    
    // MARK: - setUpUI
    func setUpUI(isOpen: Bool, title: String) {
        if isOpen {
            
        } else {
            if title == "Chat" {
                guard let data = supportVM.supportDetails else {
                     self.setUpMakeToast(msg: "Support data not loaded")
                     return
                 }
                 
                 guard data.chatSupportEnabled else {
                     self.setUpMakeToast(msg: "Chat support is currently unavailable")
                     return
                 }
                 
                 // Remove + and spaces from number
                 let phone = data.phoneNumber
                     .replacingOccurrences(of: "+", with: "")
                     .replacingOccurrences(of: " ", with: "")
                 
                 let whatsappURLString = "https://wa.me/\(phone)"
                 
                 guard let url = URL(string: whatsappURLString) else {
                     self.setUpMakeToast(msg: "Invalid WhatsApp number")
                     return
                 }
                 
                 if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url)
                 } else {
                     self.setUpMakeToast(msg: "WhatsApp is not installed on this device")
                 }
            } else {
                guard let phone = supportVM.supportDetails?.phoneNumber,
                      let url = URL(string: "tel://\(phone)") else {
                    self.setUpMakeToast(msg: "Invalid phone number")
                    return
                }
                
                UIApplication.shared.open(url)
            }
           
        }
    }

}
