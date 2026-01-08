//
//  HelpAndFAQsVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 08/01/26.
//

import UIKit

struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool
}

class HelpAndFAQsVC: UIViewController {

    @IBOutlet weak var tblViewFAQs: UITableView!
    
    var faqList: [FAQItem] = [
        FAQItem(question: "How do I book a recovery service?",
                answer: "Open the app, select the service you need (towing, jump start, fuel delivery, etc.), confirm your location, and submit your request. A nearby driver will be assigned instantly.",
                isExpanded: false),
        
        FAQItem(question: "What services are available?",
                answer: "We provide towing, jump start, fuel delivery and roadside assistance.",
                isExpanded: false),
        
        FAQItem(question: "Can I track the driver live?",
                answer: "Yes, you can track the driver in real time.",
                isExpanded: false),
        
        FAQItem(question: "Are there any hidden charges?",
                answer: "No, all charges are shown before booking.",
                isExpanded: false),
        
        FAQItem(question: "What payment methods are accepted?",
                answer: "Yes, you can track the driver in real time.",
                isExpanded: false),
        
        FAQItem(question: "Can I cancel my booking?",
                answer: "Yes, you can track the driver in real time.",
                isExpanded: false),
        
        FAQItem(question: "What roadside services do you provide?",
                answer: "No, all charges are shown before booking.",
                isExpanded: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewFAQs.register(UINib(nibName: "FAQsTblViewCell", bundle: nil), forCellReuseIdentifier: "FAQsTblViewCell")
        tblViewFAQs.delegate = self
        tblViewFAQs.dataSource = self
        
        tblViewFAQs.rowHeight = UITableView.automaticDimension
        tblViewFAQs.estimatedRowHeight = 40
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension HelpAndFAQsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewFAQs.dequeueReusableCell(withIdentifier: "FAQsTblViewCell") as! FAQsTblViewCell
        
        let item = faqList[indexPath.row]
        
        cell.lblQuation.text = item.question
        cell.lblAnswer.text = item.answer
        
        cell.lblAnswer.isHidden = !item.isExpanded
        cell.viewMiddelLine.isHidden = !item.isExpanded
        cell.imgPlus.image = UIImage(named: item.isExpanded ? "ic_minus" : "ic_plus")
        cell.viewMain.backgroundColor = item.isExpanded ? .grayBase2 : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Store old state of tapped cell
        let wasExpanded = faqList[indexPath.row].isExpanded

        // Close all
        for i in 0..<faqList.count {
            faqList[i].isExpanded = false
        }

        // If it was NOT expanded before, then open it
        if !wasExpanded {
            faqList[indexPath.row].isExpanded = true
        }

        tableView.reloadData()
    }
    
}
