//
//  ChatListTVCell.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 07/01/26.
//

import UIKit

class ChatListTVCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var viewMsgCount: UIView!
    @IBOutlet weak var lblMsgCount: UILabel!

    var chatListData: InboxItem? {
        didSet {
            lblName.text = chatListData?.chatPartner ?? ""
            lblBookingId.text = "Recovery Service #\(chatListData?.bookingId ?? 0)"
            imgProfile.loadFromUrlString(chatListData?.partnerImage ?? "", placeholder: "ic_placeholder_user".image)
            lblMsg.text = chatListData?.lastMessage ?? ""

            let time = chatListData?.lastMessageTime?.toDisplayDate(displayFormat: "HH:mm", apiTimeZone: .current)
            lblTime.text = time

            viewMsgCount.isHidden = (chatListData?.unreadCount ?? 0) > 0 ? false : true
            lblMsgCount.text = "\(chatListData?.unreadCount ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
