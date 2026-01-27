//
//  RecoveryServiceVC.swift
//  Fixmycar UAE
//
//  Created by iMac on 23/01/26.
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
    
    // variabel
    var arrVehicleType: [VehicleTypeModel] = []
    
    var pickUpLatitude: Double = 0.0
    var pickUpLangitude: Double = 0.0
    
    var dropLatitude: Double = 0.0
    var dropLangitude: Double = 0.0
    
    var isScheduleBooking: Bool = true
    
    // MARK: - view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        selectBookService()
        // Do any additional setup after loading the view.
    }
    // MARK: - setUp VehicleType
    func setUpVehicleType() -> [VehicleTypeModel] {
        var model: [VehicleTypeModel] = []
        
        let car = VehicleTypeModel(imgVehicle: "ic_car_vehicle", nameVehicle: "Car")
        let bike = VehicleTypeModel(imgVehicle: "ic_bike_vehicle", nameVehicle: "Bike")
        let van = VehicleTypeModel(imgVehicle: "ic_van_vehicle", nameVehicle: "Van")
        let truck = VehicleTypeModel(imgVehicle: "ic_truck_vehicle", nameVehicle: "Truck")
        
        model.append(car)
        model.append(bike)
        model.append(van)
        model.append(truck)
        
        return model
    }
    
    // MARK: - TV height set
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
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
            let vc = BookingConfirmationPopupVC()
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
                let vc = BookingFareAmountVC()
                vc.viewModel.pickUpAddress = txtPickupLocation.text ?? ""
                vc.viewModel.dropAddress = txtDropLocation.text ?? ""
                vc.viewModel.pickUpLatitude = pickUpLatitude
                vc.viewModel.pickUpLongitude = pickUpLangitude
                vc.viewModel.dropLatitude = dropLatitude
                vc.viewModel.dropLongitude = dropLangitude
                vc.viewModel.isScheduleBooking = isScheduleBooking
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.present(vc, animated: true)
        } else {
            let vc = BookingFareAmountVC()
            vc.viewModel.pickUpAddress = txtPickupLocation.text ?? ""
            vc.viewModel.dropAddress = txtDropLocation.text ?? ""
            vc.viewModel.pickUpLatitude = pickUpLatitude
            vc.viewModel.pickUpLongitude = pickUpLangitude
            vc.viewModel.dropLatitude = dropLatitude
            vc.viewModel.dropLongitude = dropLangitude
            vc.viewModel.isScheduleBooking = isScheduleBooking
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReasonListTblViewCell.identifier) as! ReasonListTblViewCell
        
        cell.lblBottomLine.isHidden = tableView.isLastRow(at: indexPath) ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - CV Delegate & DataSource
extension RecoveryServiceVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setUpVehicleType().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleTypeCVCell.identifier, for: indexPath) as! VehicleTypeCVCell
        
        let dicData = setUpVehicleType()[indexPath.item]
        
        cell.imgPick.image = dicData.imgVehicle.image
        cell.lblName.text = dicData.nameVehicle
        
        return cell
    }
    
    
}

// MARK: - CV Flowlayout
extension RecoveryServiceVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
