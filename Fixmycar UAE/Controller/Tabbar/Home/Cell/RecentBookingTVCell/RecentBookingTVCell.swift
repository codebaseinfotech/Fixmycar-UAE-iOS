//
//  RecentBookingTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class RecentBookingTVCell: UITableViewCell {
   
    @IBOutlet weak var viewRecentBooking: RecentBookingsView!
    
    var recentBooking: HomeBooking? {
        didSet {
            viewRecentBooking.lblType.text = recentBooking?.serviceName
            viewRecentBooking.lblTime.text = recentBooking?.jobDate
            viewRecentBooking.lblPrice.text = "\(recentBooking?.currency ?? "") \(recentBooking?.amount ?? "")"
            viewRecentBooking.lblStatus.text = recentBooking?.status?.capitalized
            
            viewRecentBooking.lblPickLocation.text = recentBooking?.pickupAddress ?? ""
            viewRecentBooking.lblDropLocation.text = recentBooking?.dropAddress ?? ""
            
            let jobStatus: JobStatus = JobStatus(rawValue: recentBooking?.status ?? "") ?? .accepted
            
            switch jobStatus {
            case .pending:
                viewRecentBooking.lblStatus.text = "Pending"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.pending_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.pending_border
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.pending_border
                
            case .accepted:
                viewRecentBooking.lblStatus.text = "Accepted"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.started_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.started_border
            case .started:
                viewRecentBooking.lblStatus.text = "Started"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.started_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.started_border
            case .onTheWayToPickup:
                viewRecentBooking.lblStatus.text = "On the way to pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.one_way_to_pickup_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.one_way_to_pickup_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.one_way_to_pickup_border
            case .nearPickup:
                viewRecentBooking.lblStatus.text = "Near pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.near_pickup_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.near_pickup_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.near_pickup_border
            case .arrivedAtPickup:
                viewRecentBooking.lblStatus.text = "Arrived at pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.arrived_pick_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.arrived_pick_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.arrived_pick_border
            case .pickupCompleted:
                viewRecentBooking.lblStatus.text = "Pickup completed"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.pickup_completed_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.pickup_completed_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.pickup_completed_border
            case .onTheWayToDelivery:
                viewRecentBooking.lblStatus.text = "On the way to delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.one_way_to_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.one_way_to_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.one_way_to_delivery_border
            case .nearDelivery:
                viewRecentBooking.lblStatus.text = "Near delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.near_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.near_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.near_delivery_border
            case .arrivedAtDelivery:
                viewRecentBooking.lblStatus.text = "Arrived at delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.arrived_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.arrived_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.arrived_delivery_border
            case .completed:
                viewRecentBooking.lblStatus.text = "Completed"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.completrd_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.completrd_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.completrd_border
            case .cancelled:
                viewRecentBooking.lblStatus.text = "Cancelled"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.cancelled_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.cancelled_border
            
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.cancelled_border
            }
        }
    }
    
    var historyBooking: BookingItem? {
        didSet {
            viewRecentBooking.lblType.text = historyBooking?.serviceType
            viewRecentBooking.lblTime.text = historyBooking?.createdAt?.toDisplayDate()
            viewRecentBooking.lblPrice.text = "\(historyBooking?.currency ?? "") \(historyBooking?.totalAmount ?? 0)"
            viewRecentBooking.lblStatus.text = historyBooking?.status?.capitalized
            
            viewRecentBooking.lblPickLocation.text = historyBooking?.pickupAddress ?? ""
            viewRecentBooking.lblDropLocation.text = historyBooking?.dropoffAddress ?? ""
            
            let jobStatus: JobStatus = JobStatus(rawValue: historyBooking?.status ?? "") ?? .accepted
            
            switch jobStatus {
            case .pending:
                viewRecentBooking.lblStatus.text = "pending"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.pending_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.pending_border
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.pending_border
                
            case .accepted:
                viewRecentBooking.lblStatus.text = "Accepted"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.started_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.started_border
            case .started:
                viewRecentBooking.lblStatus.text = "Started"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.started_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.started_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.started_border
            case .onTheWayToPickup:
                viewRecentBooking.lblStatus.text = "On the way to pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.one_way_to_pickup_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.one_way_to_pickup_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.one_way_to_pickup_border
            case .nearPickup:
                viewRecentBooking.lblStatus.text = "Near pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.near_pickup_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.near_pickup_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.near_pickup_border
            case .arrivedAtPickup:
                viewRecentBooking.lblStatus.text = "Arrived at pickup"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.arrived_pick_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.arrived_pick_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.arrived_pick_border
            case .pickupCompleted:
                viewRecentBooking.lblStatus.text = "Pickup completed"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.pickup_completed_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.pickup_completed_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.pickup_completed_border
            case .onTheWayToDelivery:
                viewRecentBooking.lblStatus.text = "On the way to delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.one_way_to_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.one_way_to_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.one_way_to_delivery_border
            case .nearDelivery:
                viewRecentBooking.lblStatus.text = "Near delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.near_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.near_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.near_delivery_border
            case .arrivedAtDelivery:
                viewRecentBooking.lblStatus.text = "Arrived at delivery"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.arrived_delivery_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.arrived_delivery_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.arrived_delivery_border
            case .completed:
                viewRecentBooking.lblStatus.text = "Completed"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.completrd_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.completrd_border
                
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.completrd_border
            case .cancelled:
                viewRecentBooking.lblStatus.text = "Cancelled"
                
                viewRecentBooking.viewStatus.backgroundColor = UIColor.AppColor.cancelled_bg
                viewRecentBooking.viewStatus.borderColor = UIColor.AppColor.cancelled_border
            
                viewRecentBooking.lblStatus.textColor = UIColor.AppColor.cancelled_border
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
