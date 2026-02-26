//
//  ChatListTVCell.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import UIKit

class ChatListTVCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var viewMsgCount: UIView!
    @IBOutlet weak var lblMsgCount: UILabel!
    
    var chatListData: InboxItem? {
        didSet {
            lblName.text = chatListData?.chatPartner ?? ""
            imgProfile.loadFromUrlString(chatListData?.chatPartner ?? "", placeholder: "ic_placeholder_user".image)
            lblMsg.text = chatListData?.lastMessage ?? ""
            
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
