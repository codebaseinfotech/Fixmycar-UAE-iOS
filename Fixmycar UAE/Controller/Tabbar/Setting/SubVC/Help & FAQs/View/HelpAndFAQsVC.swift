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
    
    var faqList: [FAQItem] = []
    
    var viewModel = FAQsVM()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewFAQs.register(UINib(nibName: "FAQsTblViewCell", bundle: nil), forCellReuseIdentifier: "FAQsTblViewCell")
        tblViewFAQs.delegate = self
        tblViewFAQs.dataSource = self
        
        tblViewFAQs.rowHeight = UITableView.automaticDimension
        tblViewFAQs.estimatedRowHeight = 40
        
        getFaqsData()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - getFaqData
    func getFaqsData() {
        viewModel.getFaqs()
        
        viewModel.successFaqs = { [weak self] in
            guard let self = self else { return }
            
            // Map API FAQs to local FAQItem array
            self.faqList = self.viewModel.faqs.map {
                FAQItem(question: $0.question ?? "", answer: $0.answer ?? "", isExpanded: false)
            }
            
            DispatchQueue.main.async {
                self.tblViewFAQs.reloadData()
            }
        }
        
        viewModel.failuerFaqs = { error in
            print("❌ Legal Info Error:", error)
        }
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
