//
//  EditProfileVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/01/26.
//

import UIKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtNumber: AppTextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblTFullName: UILabel! {
        didSet {
            let fullText = "Full name *".localized

            lblTFullName.attributedText = fullText.attributedText(
                defaultFont: UIFont.AppFont.bold(14),
                defaultColor: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1),
                highlightText: "*",
                highlightColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            )
        }
    }
    @IBOutlet weak var lblTMobileNumber: UILabel! {
        didSet {
            let fullText = "Mobile number *".localized

            lblTMobileNumber.attributedText = fullText.attributedText(
                defaultFont: UIFont.AppFont.bold(14),
                defaultColor: #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1),
                highlightText: "*",
                highlightColor: #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1)
            )
        }
    }
    
    
    var editProfileVM = EditProfileVM()
    var isUploadProfile: Bool = false
    var selectedVehicleTypeId: String?
    let imagePicker = UIImagePickerController()

    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let joinedAt = FCUtilites.getCurrentUser()?.joinedAt ?? ""
        let result = formattedMemberSince(from: joinedAt)
        lblTime.text = result
        lblName.text = FCUtilites.getCurrentUser()?.name ?? ""
        txtFullName.text = FCUtilites.getCurrentUser()?.firstName ?? ""
        txtNumber.text = FCUtilites.getCurrentUser()?.phone ?? ""
        txtEmail.text = FCUtilites.getCurrentUser()?.email ?? ""
        
        imgUser.loadFromUrlString(FCUtilites.getCurrentUser()?.avatar ?? "", placeholder: "ic_placeholder_user".image)
               
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Method

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCamera(_ sender: Any) {
        showImagePickerSheet()
    }
 
    @IBAction func tappedSaveChanges(_ sender: Any) {
        guard let fullName = txtFullName.text, !fullName.isEmpty else {
            self.setUpMakeToast(msg: "Please enter full name")
            return
        }
        
        updateProfileData()
    }

    // MARK: - updateProfile
    func updateProfileData() {
        
        let param: [String: String] = [
            "first_name": txtFullName.text ?? "",
            "mobile": txtNumber.text ?? "",
            "email": txtEmail.text ?? ""
        ]
        
        editProfileVM.updateProfile(parameters: param, profileImage: imgUser.image, isUpdateProfileImg: isUploadProfile)
        editProfileVM.successUpdateProfile = {
            self.tappedBack(self)
        }
        editProfileVM.failuerUpdateProfile = { msg in
            self.setUpMakeToast(msg: msg)
        }
    }
    
    // MARK: - setUp Join Date
    func formattedMemberSince(from dateString: String) -> String {
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)
        
        return "Member since \(day)\(daySuffix(day)) \(month), \(year)"
    }

    func daySuffix(_ day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    
    // MARK: - setUp Camera & Gallry
    func showImagePickerSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        // iPad fix
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }

    func openGallery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }
        
        if let image = selectedImage {
            // ✅ Set profile image
            isUploadProfile = true
            imgUser.image = image
            
            // Optional: make it circular
            imgUser.layer.cornerRadius = imgUser.frame.height / 2
            imgUser.clipsToBounds = true
        }
        
        picker.dismiss(animated: true)
    }
    
}
