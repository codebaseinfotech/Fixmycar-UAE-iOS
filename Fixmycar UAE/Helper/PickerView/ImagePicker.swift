//
//  ImagePicker.swift
//  Look_Vendor
//
//  Created by Codebase Infotech on 24/07/23.
//

import Foundation
import MobileCoreServices
import UIKit


public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, imageURL: URL?, info: [UIImagePickerController.InfoKey: Any]?)
    func didSelectDoc(urls: [URL]?)
}

extension ImagePickerDelegate {
    func didSelectDoc(urls: [URL]?) {}
}

//MARK: - ImagePicker class.

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    var importMenu: UIDocumentPickerViewController!
    var chooseFromFile = false
    var info: [UIImagePickerController.InfoKey: Any]?
        
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
//    public func present(from sourceView: UIView,ipadSourceView:UIButton) {
//        if let vc = sourceView.parentController {
//            vc.view.endEditing(true)
//        }
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        if let action = self.action(for: .camera, title: CommonStrings.takePhotoStr) {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .savedPhotosAlbum, title: CommonStrings.cameraRollStr) {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .photoLibrary, title: CommonStrings.photoLibraryStr) {
//            alertController.addAction(action)
//        }
//
//        // Choose from file
//        if chooseFromFile {
//            let action = UIAlertAction(title: "Choose from file", style: .default) { [unowned self] _ in
//                self.importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
//                self.importMenu.delegate = self
//                self.presentationController?.present(self.importMenu, animated: true, completion: nil)
//            }
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: CommonStrings.cancel, style: .cancel, handler: nil))
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = ipadSourceView
//            alertController.popoverPresentationController?.sourceRect = ipadSourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//
//        self.presentationController?.present(alertController, animated: true)
//    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, info: [UIImagePickerController.InfoKey: Any]?) {
        controller.dismiss(animated: true, completion: nil)
        if image != nil {
            self.delegate?.didSelect(image: image, imageURL: info?[UIImagePickerController.InfoKey.imageURL] as? URL, info: info)
        }
    }
    
    private func pickerController(didSelect image: UIImage?, info: [UIImagePickerController.InfoKey: Any]?) {
        if image != nil {
            self.delegate?.didSelect(image: image, imageURL: info?[UIImagePickerController.InfoKey.imageURL] as? URL, info: info)
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, info: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil, info: nil)
        }
        self.pickerController(picker, didSelect: image, info: info)

    }
}

extension ImagePicker: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true, completion: nil)
        print("URL: \(urls)")
        self.delegate?.didSelectDoc(urls: urls)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
