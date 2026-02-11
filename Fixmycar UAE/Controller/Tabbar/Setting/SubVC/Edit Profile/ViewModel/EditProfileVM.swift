//
//  EditProfileVM.swift
//  Fixmycar UAE
//
//  Created by Kenil on 11/02/26.
//

import Foundation

class EditProfileVM {
    var successUpdateProfile: (() -> Void)?
    var failuerUpdateProfile: ((String) -> Void)?

    func updateProfile(parameters: [String: String], profileImage: UIImage?, isUpdateProfileImg: Bool = false) {
        
        if isUpdateProfileImg {
            var files: [MultipartFile] = []
            
            if let data = profileImage?.jpegDataSafe() {
                files.append(MultipartFile(
                    key: "profile_photo",
                    fileName: "profile.jpg",
                    data: data,
                    mimeType: "image/jpeg"
                ))
            }
            
            APIClient.sharedInstance.uploadMultipart(
                urlString: APIEndPoint.updateProfile,
                parameters: parameters,
                files: files
            ) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(LoginSuccessResponseModel.self, from: data)
                        if response.status == true {
                            FCUtilites.saveCurrentUser(response.data?.user)
                            self.successUpdateProfile?()
                        } else {
                            self.failuerUpdateProfile?(response.message ?? "")
                        }
                        
                    } catch {
                        debugPrint("Decoding error:", error.localizedDescription)
                    }
                case .failure(let error):
                    debugPrint("Error:", error.localizedDescription)
                }
            }
        } else {
            APIClient.sharedInstance.request(
                method: .post,
                url: APIEndPoint.updateProfile,
                parameters: parameters,
                responseType: LoginSuccessResponseModel.self) { [self] response, errorMessage, statusCode in
                    APIClient.sharedInstance.hideIndicator()
                    
                    if let response = response {
                        debugPrint("SUCCESS:", response.message ?? "")
                        
                        let message = response.message
                        if statusCode == 200 {
                            if response.status == true {
                                FCUtilites.saveCurrentUser(response.data?.user)
                                successUpdateProfile?()
                            } else {
                                failuerUpdateProfile?(message ?? "")
                            }
                        } else {
                            failuerUpdateProfile?(message ?? "")
                        }
                        
                    } else {
                        debugPrint("ERROR:", errorMessage ?? "")
                        failuerUpdateProfile?(errorMessage ?? "")
                    }
                }
        }
        
    }
    
}
