//
//  NewVersionAvailablePopup.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/03/26.
//

import UIKit

class NewVersionAvailablePopup: UIViewController {

    @IBOutlet weak var btnLater: AppButton!

    @IBOutlet weak var btnUpdateNow: AppButton!

    var isForceUpdate: Bool = false
    var onLater: (() -> Void)?
    var onUpdateNow: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        btnLater.isHidden = isForceUpdate ? true : false
        isModalInPresentation = isForceUpdate
    }

    @IBAction func tappedLater(_ sender: Any) {
        dismiss(animated: false) {
            self.onLater?()
        }
    }

    @IBAction func tappedUpdateNow(_ sender: Any) {
        self.onUpdateNow?()
    }

}
