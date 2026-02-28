//
//  ScheduleDateVC.swift
//  Fixmycar UAE
//
//  Created by Ankit on 26/01/26.
//

import UIKit

class ScheduleDateVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var onTappedConfirm: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - DatePicker Setup
    func setupDatePicker() {
        
        datePicker.datePickerMode = .dateAndTime
        
        // Wheel style (like iOS classic)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // Optional settings
        datePicker.minimumDate = Date()               // future only
        datePicker.minuteInterval = 30                // 00, 30
        datePicker.locale = Locale(identifier: "en_US")
        datePicker.timeZone = .current
    }
    
    // MARK: - Confirm Button
    @IBAction func tappedConfir(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy hh:mm a"
        
        let selectedDate = formatter.string(from: datePicker.date)
        debugPrint("Selected Date:", selectedDate)
        
        onTappedConfirm?(selectedDate)
        // Example: pass value back / show / save
        // lblDate.text = selectedDate
        // delegate?.didSelectDate(datePicker.date)
        
        dismiss(animated: true)
    }
    
    
    
}
