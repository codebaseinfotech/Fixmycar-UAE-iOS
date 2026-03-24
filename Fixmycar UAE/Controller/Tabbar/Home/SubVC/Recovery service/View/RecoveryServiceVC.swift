//
//  RecoveryServiceVC.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 23/01/26.
//

import UIKit

struct VehicleTypeModel {
    var imgVehicle: String
    var nameVehicle: String
}

class RecoveryServiceVC: UIViewController {

    @IBOutlet weak var lblBookService: AppLabel!
    @IBOutlet weak var lblLineBookService: UILabel!
    @IBOutlet weak var lblScheduleLater: AppLabel!
    @IBOutlet weak var lblLineScheduleLater: UILabel!
    @IBOutlet weak var heightConstBookServiceLine: NSLayoutConstraint!
    @IBOutlet weak var heightConstScheduleLaterLine: NSLayoutConstraint!
    
    @IBOutlet weak var txtChooseDate: UITextField!
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropLocation: UITextField!
    
    @IBOutlet weak var collectionViewVehicleType: UICollectionView! {
        didSet {
            collectionViewVehicleType.register(VehicleTypeCVCell.nib, forCellWithReuseIdentifier: VehicleTypeCVCell.identifier)
            collectionViewVehicleType.delegate = self
            collectionViewVehicleType.dataSource = self
        }
    }
    @IBOutlet weak var tblViewVehicleIssue: UITableView! {
        didSet {
            tblViewVehicleIssue.delegate = self
            tblViewVehicleIssue.dataSource = self
            
            tblViewVehicleIssue.register(ReasonListTblViewCell.nib, forCellReuseIdentifier: ReasonListTblViewCell.identifier)
            tblViewVehicleIssue.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
    }
    @IBOutlet weak var heightTblViewVehicleType: NSLayoutConstraint!
    
    @IBOutlet weak var txtAdditionalNotes: UITextView!
    @IBOutlet weak var viewDateShedule: UIView! {
        didSet {
            viewDateShedule.isHidden = true
        }
    }
    
    @IBOutlet weak var lblVehicleMake: AppLabel!
    @IBOutlet weak var lblVehicleModel: AppLabel!
    
    @IBOutlet weak var viewVehicleMake: UIView!
    @IBOutlet weak var viewVehicleModel: UIView!
     
    @IBOutlet weak var collectionViewVehicleImage: UICollectionView! {
        didSet {
            collectionViewVehicleImage.register(VehicleImageCVCell.nib, forCellWithReuseIdentifier: VehicleImageCVCell.identifier)
            collectionViewVehicleImage.delegate = self
            collectionViewVehicleImage.dataSource = self
        }
    }
    
    // variabel
    var arrVehicleType: [VehicleTypeModel] = []
    
    var pickUpLatitude: Double = 0.0
    var pickUpLangitude: Double = 0.0
    
    var dropLatitude: Double = 0.0
    var dropLangitude: Double = 0.0
    
    var isScheduleBooking: Bool = true
    
    var selectedVehicleIssueIndex: Int? = nil
    var selectedVehicleType: Int? = nil
    var recoveryVM = RecoveryServiceVM()
    
    var arrVehicleImage: [UIImage] = []
    let imagePicker = UIImagePickerController()
    
    var dropDownVehicleMake = DropDown()
    var dropDownVehicleModel = DropDown()
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recoveryVM.getVehicleType()
        recoveryVM.getVehicleIssue()
        recoveryVM.getVehicelMake()
        
        recoveryVM.successVehicleType = {
            self.collectionViewVehicleType.reloadData()
        }
        recoveryVM.successVehicleIssue = {
            self.tblViewVehicleIssue.reloadData()
        }
        recoveryVM.successVehicleMake = {
            self.setDropDownVehicleMake()
        }
        
        recoveryVM.successVehicleModel = {
            self.setDropDownVehicleModel()
        }
        
        recoveryVM.failureVehicleIssue = { (message) in
            self.setUpMakeToast(msg: message)
        }
        recoveryVM.failureVehicleType = { (message) in
            self.setUpMakeToast(msg: message)
        }
        recoveryVM.failureVehicleMake = { (message) in
            self.setUpMakeToast(msg: message)
        }
        recoveryVM.failureVehicleModel = { (message) in
            self.setUpMakeToast(msg: message)
        }
        
        selectBookService()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setUpDropDown
    func setDropDownVehicleMake() {
        var arrVehicleMake: [String] = []

        for obj in recoveryVM.vehicleMake! {
            
            if obj.status == true {
                arrVehicleMake.append(obj.name ?? "")
            }
        }

        dropDownVehicleMake.dataSource = arrVehicleMake
        dropDownVehicleMake.anchorView = viewVehicleMake
        dropDownVehicleMake.direction = .bottom

        dropDownVehicleMake.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            debugPrint("Selected item: \(item) at index: \(index)")

            self.lblVehicleMake.text = item
            self.lblVehicleModel.text = "Select Model"
            
            for obj in recoveryVM.vehicleMake! {
                if obj.name == item {
                    self.recoveryVM.getVehicelModel(id: obj.id ?? 0)
                }
            }
        }
        
        dropDownVehicleMake.bottomOffset = CGPoint(x: 0, y: viewVehicleMake.bounds.height)
        dropDownVehicleMake.topOffset = CGPoint(x: 0, y: -viewVehicleMake.bounds.height)
        dropDownVehicleMake.dismissMode = .onTap
        dropDownVehicleMake.textColor = UIColor.black
        dropDownVehicleMake.backgroundColor = UIColor(red: 255/255, green:  255/255, blue:  255/255, alpha: 1)
        dropDownVehicleMake.selectionBackgroundColor = UIColor.clear
        
        dropDownVehicleMake.reloadAllComponents()
    }
    
    func setDropDownVehicleModel() {
        var arrVehicleModel: [String] = []

        for obj in recoveryVM.vehicleModel! {
            if obj.status == true {
                arrVehicleModel.append(obj.name ?? "")
            }
        }

        dropDownVehicleModel.dataSource = arrVehicleModel
        dropDownVehicleModel.anchorView = viewVehicleModel
        dropDownVehicleModel.direction = .bottom

        dropDownVehicleModel.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            debugPrint("Selected item: \(item) at index: \(index)")

            self.lblVehicleModel.text = item
        }
        
        dropDownVehicleModel.bottomOffset = CGPoint(x: 0, y: viewVehicleModel.bounds.height)
        dropDownVehicleModel.topOffset = CGPoint(x: 0, y: -viewVehicleModel.bounds.height)
        dropDownVehicleModel.dismissMode = .onTap
        dropDownVehicleModel.textColor = UIColor.black
        dropDownVehicleModel.backgroundColor = UIColor(red: 255/255, green:  255/255, blue:  255/255, alpha: 1)
        dropDownVehicleModel.selectionBackgroundColor = UIColor.clear
        
        dropDownVehicleModel.reloadAllComponents()
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newsize = change?[.newKey] as? CGSize {
                self.heightTblViewVehicleType.constant = newsize.height
            }
        }
    }

    // MARK: - Action Method
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedBookServiceNow(_ sender: Any) {
        selectBookService()
    }
    
    @IBAction func tappedScheduleForLater(_ sender: Any) {
        selectScheduleLater()
    }
    @IBAction func tappedChooseDateTime(_ sender: Any) {
        let vc = ScheduleDateVC()
        if let sheet = vc.sheetPresentationController {
            // Create a custom detent that returns a fixed height
            let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                return 300
            }
            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
        }
        vc.sheetPresentationController?.delegate = self
        
        vc.onTappedConfirm = { selectedDate in
            self.txtChooseDate.text = selectedDate
        }
        
        self.present(vc, animated: true)
    }
    @IBAction func tappedContinue(_ sender: Any) {
        if isScheduleBooking {
            guard validateBooking(isShedule: true) else { return }
            
            /*let vc = BookingConfirmationPopupVC()
            if let sheet = vc.sheetPresentationController {
                // Create a custom detent that returns a fixed height
                let fixedDetent = UISheetPresentationController.Detent.custom(identifier: .init("fixed326")) { context in
                    return 200
                }
                sheet.detents = [fixedDetent]
                sheet.prefersGrabberVisible = true // Optional: adds a grabber bar at top
            }
            vc.sheetPresentationController?.delegate = self
            vc.isConfirmSchedule = true
            
            vc.onTappedConfirmBooking = { [self] in
                
                CreateBooking.shared.booking_type = "scheduled"
                CreateBooking.shared.pickup_address = txtPickupLocation.text ?? ""
                CreateBooking.shared.dropoff_address = txtDropLocation.text ?? ""
                CreateBooking.shared.pickup_lat = pickUpLatitude
                CreateBooking.shared.pickup_lng = pickUpLangitude
                CreateBooking.shared.dropoff_lat = dropLatitude
                CreateBooking.shared.dropoff_lng = dropLangitude
                CreateBooking.shared.scheduled_at = txtChooseDate.text ?? ""
                CreateBooking.shared.isScheduleBooking = isScheduleBooking
                CreateBooking.shared.additional_notes = txtAdditionalNotes.text ?? ""
                
                let vc = BookingFareAmountVC()
                vc.viewModel.isScheduleBooking = isScheduleBooking
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.present(vc, animated: true)*/
            CreateBooking.shared.booking_type = "scheduled"
            CreateBooking.shared.pickup_address = txtPickupLocation.text ?? ""
            CreateBooking.shared.dropoff_address = txtDropLocation.text ?? ""
            CreateBooking.shared.pickup_lat = pickUpLatitude
            CreateBooking.shared.pickup_lng = pickUpLangitude
            CreateBooking.shared.dropoff_lat = dropLatitude
            CreateBooking.shared.dropoff_lng = dropLangitude
            CreateBooking.shared.scheduled_at = txtChooseDate.text ?? ""
            CreateBooking.shared.isScheduleBooking = isScheduleBooking
            CreateBooking.shared.additional_notes = txtAdditionalNotes.text ?? ""
            CreateBooking.shared.vehicle_make = lblVehicleMake.text ?? ""
            CreateBooking.shared.vehicle_model = lblVehicleModel.text ?? ""
            CreateBooking.shared.vehical_image = arrVehicleImage
            
            let vc = BookingFareAmountVC()
            vc.viewModel.isScheduleBooking = isScheduleBooking
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            
            guard validateBooking() else { return }
            
            CreateBooking.shared.booking_type = "immediate"
            CreateBooking.shared.pickup_address = txtPickupLocation.text ?? ""
            CreateBooking.shared.dropoff_address = txtDropLocation.text ?? ""
            CreateBooking.shared.pickup_lat = pickUpLatitude
            CreateBooking.shared.pickup_lng = pickUpLangitude
            CreateBooking.shared.dropoff_lat = dropLatitude
            CreateBooking.shared.dropoff_lng = dropLangitude
            CreateBooking.shared.isScheduleBooking = false
            CreateBooking.shared.additional_notes = txtAdditionalNotes.text ?? ""
            CreateBooking.shared.vehicle_make = lblVehicleMake.text ?? ""
            CreateBooking.shared.vehicle_model = lblVehicleModel.text ?? ""
            CreateBooking.shared.vehical_image = arrVehicleImage
            
            let vc = BookingFareAmountVC()
            vc.viewModel.isScheduleBooking = false
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func tappedPickupLocation(_ sender: Any) {
        let vc = BookingMapVC()
        vc.delegateLocation = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedDropLocation(_ sender: Any) {
        let vc = BookingMapVC()
        vc.delegateLocation = self
        vc.isDropAddress = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedSelectMake(_ sender: Any) {
        dropDownVehicleMake.show()
    }
    @IBAction func tappedSelectModel(_ sender: Any) {
        dropDownVehicleModel.show()
    }
    
    // MARK: - validate
    func validateBooking(isShedule: Bool = false) -> Bool {
        
        if isShedule {
            guard let dateTime = txtChooseDate.text, !dateTime.isEmpty else {
                self.setUpMakeToast(msg: "Please select date and time")
                return false
            }
        }
        
        guard let pickUpLocation = txtPickupLocation.text, !pickUpLocation.isEmpty else {
            self.setUpMakeToast(msg: "Please select pickup location")
            return false
        }
        
        guard let dropLocation = txtDropLocation.text, !dropLocation.isEmpty else {
            self.setUpMakeToast(msg: "Please select drop location")
            return false
        }
        
        guard let vehicleType = selectedVehicleType, vehicleType >= 0 else {
            self.setUpMakeToast(msg: "Please select vehicle type")
            return false
        }
        
        guard let vehicleIssue = selectedVehicleIssueIndex, vehicleIssue >= 0 else {
            self.setUpMakeToast(msg: "Please select vehicle issue")
            return false
        }
        
        guard let vehicleMake = lblVehicleMake.text, vehicleMake != "Select Make" else{
            self.setUpMakeToast(msg: "Please select vehicle make")
            return false
        }
        
        guard let vehicleModel = lblVehicleModel.text, vehicleModel != "Select Model" else{
            self.setUpMakeToast(msg: "Please select vehicle model")
            return false
        }
        
        guard arrVehicleImage.count > 0 else {
            self.setUpMakeToast(msg: "Please upload vehicle images")
            return false
        }
        
        return true
    }
    // MARK: - selectBookService
    func selectBookService() {
        heightConstBookServiceLine.constant = 2
        heightConstScheduleLaterLine.constant = 1
        
        lblBookService.textColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        lblScheduleLater.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        
        lblBookService.font = UIFont.AppFont.bold(14)
        lblScheduleLater.font = UIFont.AppFont.medium(14)
        
        lblLineBookService.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        lblLineScheduleLater.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        viewDateShedule.isHidden = true
        isScheduleBooking = false
    }
    
    func selectScheduleLater() {
        heightConstBookServiceLine.constant = 1
        heightConstScheduleLaterLine.constant = 2
        
        lblBookService.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        lblScheduleLater.textColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        
        lblBookService.font = UIFont.AppFont.medium(14)
        lblScheduleLater.font = UIFont.AppFont.bold(14)
        
        lblLineBookService.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        lblLineScheduleLater.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
        
        viewDateShedule.isHidden = false
        isScheduleBooking = true
    }
    
    
    
}

// MARK: - onTappedConfirmLocation
extension RecoveryServiceVC: onTappedConfirmLocation {
    func tappedConfirmLocation(isDropLocation: Bool, location: String, lat: Double, lang: Double) {
        if isDropLocation {
            txtDropLocation.text = location
            
            dropLatitude = lat
            dropLangitude = lang
            
        } else {
            txtPickupLocation.text = location
            
            pickUpLatitude = lat
            pickUpLangitude = lang
        }
    }
    
    
}

// MARK: - TV Delegate & DataSource
extension RecoveryServiceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recoveryVM.vehicleIssue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReasonListTblViewCell.identifier) as? ReasonListTblViewCell else {
            return UITableViewCell()
        }

        cell.lblReason.text = recoveryVM.vehicleIssue?[indexPath.row].name
        cell.imgCheckBox.image = selectedVehicleIssueIndex == indexPath.item ? "ic_check".image : "ic_uncheck".image

        cell.lblBottomLine.isHidden = tableView.isLastRow(at: indexPath) ? true : false

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVehicleIssueIndex = indexPath.item
        CreateBooking.shared.issue = recoveryVM.vehicleIssue?[indexPath.row].id
        tableView.reloadData()
    }
}

// MARK: - CV Delegate & DataSource
extension RecoveryServiceVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case collectionViewVehicleImage:
            return 2
            
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewVehicleType:
            return recoveryVM.vehicleType?.count ?? 0
            
        case collectionViewVehicleImage:
            return section == 0 ? 1 : arrVehicleImage.count
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewVehicleType:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleTypeCVCell.identifier, for: indexPath) as? VehicleTypeCVCell else {
                return UICollectionViewCell()
            }

            let dicData = recoveryVM.vehicleType?[indexPath.item]

            cell.imgPick.loadFromUrlString(dicData?.image)
            cell.lblName.text = dicData?.name

            cell.viewMain.borderColor = selectedVehicleType == indexPath.row ? #colorLiteral(red: 0.8196078431, green: 0, blue: 0.04705882353, alpha: 1) : #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)

            return cell
            
        case collectionViewVehicleImage:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleImageCVCell.identifier, for: indexPath) as? VehicleImageCVCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.section == 0 {
                cell.btnClose.isHidden = true
                cell.viewMainUpload.isHidden = false
                cell.viewVehicleImageMain.isHidden = true
            } else {
                cell.btnClose.isHidden = false
                cell.viewMainUpload.isHidden = true
                cell.viewVehicleImageMain.isHidden = false
                
                let image = arrVehicleImage[indexPath.item]
                cell.imgVehicleImage.image = image
                
                cell.btnClose.tag = indexPath.item

                cell.tappedRemove = { [weak self] index in
                    guard let self = self else { return }
                    
                    if index < self.arrVehicleImage.count {
                        self.arrVehicleImage.remove(at: index)
                        self.collectionViewVehicleImage.reloadData()
                    }
                }
                
            }

            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewVehicleType:
            selectedVehicleType = indexPath.row
            CreateBooking.shared.vehicle_type = recoveryVM.vehicleType?[indexPath.row].id
            collectionView.reloadData()
            
        case collectionViewVehicleImage:
            if indexPath.section == 0 {
                showImagePickerSheet()
            }
            
        default:
            break
        }
    }
    
    
}

// MARK: - CV Flowlayout
extension RecoveryServiceVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewVehicleType:
            return CGSize(width: 90, height: 115)
            
        case collectionViewVehicleImage:
            return CGSize(width: 123, height: 125)
            
        default:
            return CGSize()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case collectionViewVehicleType:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        case collectionViewVehicleImage:
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - Sheet Presentation Delegate
extension RecoveryServiceVC: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let overlayView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                overlayView.alpha = 0
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
            
        }
    }
}

// MARK: - UIImagePickerDelegate
extension RecoveryServiceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            arrVehicleImage.append(image)
            
            print("Total Images: \(arrVehicleImage.count)")
            collectionViewVehicleImage.reloadData()
        }
        
        picker.dismiss(animated: true)
    }
}
