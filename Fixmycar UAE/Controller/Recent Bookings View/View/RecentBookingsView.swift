//
//  RecentBookingsView.swift
//  Fixmycar UAE
//
//  Created by iMac on 07/01/26.
//

import UIKit

class RecentBookingsView: UIView {

    @IBOutlet weak var imgBooking: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel! {
        didSet {
            lblStatus.textAlignment = .center
        }
    }
    
    @IBOutlet weak var svHistoryMain: UIStackView!
    @IBOutlet weak var lblPickLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    
    @IBOutlet weak var svLocation: UIStackView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var viewBottomMain: UIView!
    @IBOutlet weak var viewLineAddress: UIView!
    @IBOutlet weak var svPrice: UIStackView!
    
    private let nibName = String(describing: RecentBookingsView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func config(type: String = "recent_booking") {
        if type == "recent_booking" {
            svHistoryMain.isHidden = false
            viewLineAddress.isHidden = false
            svLocation.isHidden = true
            
        } else if type == "history_booking" {
            svHistoryMain.isHidden = false
            viewLineAddress.isHidden = false
            svLocation.isHidden = true
            
        } else if type == "booking_details" {
            svLocation.isHidden = true
            svHistoryMain.isHidden = false
            viewLineAddress.isHidden = false
            svPrice.isHidden = true
        } else if type == "active_job" {
            svHistoryMain.isHidden = false
            viewLineAddress.isHidden = false
            svLocation.isHidden = true
            
        }
    }
}
