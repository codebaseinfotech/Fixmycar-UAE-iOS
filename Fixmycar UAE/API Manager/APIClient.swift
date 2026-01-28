//
//  APIClient.swift
//  TorettoRecovery
//
//  Created by Ankit Gabani on 29/12/25.
//

import Foundation
import Alamofire
import SVProgressHUD
import UIKit

enum EncodingAPI: ParameterEncoding {
    case json
    case url

    func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {

        switch self {
        case .json:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)

        case .url:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}

struct MultipartFile {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
}

struct APIErrorResponse: Codable {
    let message: String
}

class APIClient: NSObject {
    
    typealias completion = ( _ result: Dictionary<String, Any>, _ error: Error?) -> ()
    
    class var sharedInstance: APIClient {
        
        struct Static {
            static let instance: APIClient = APIClient()
        }
        return Static.instance
    }
    
    var responseData: NSMutableData!
    
    func pushNetworkErrorVC()
    {
        
    }
    
    func request<T: Decodable>(
        method: HTTPMethod,
        url: APIEndPoint,
        parameters: Parameters = [:],
        pathComponent: String = "",
        needUserToken: Bool = true,
        responseType: T.Type,
        parameterEncoding: EncodingAPI = .json,
        completionHandler: @escaping (T?, String?, Int?) -> Void
    ) {
        
        let absoluteUrl = BASE_URL + url.rawValue + pathComponent
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Language": Language.shared.currentAppLang,
            /*"DeviceType": TRUtilites.deviceType(),
            "DeviceID": TRUtilites.deviceID(),
            "Latitude": "\(AppDelegate.appDelegate.latitude ?? 0.0)",
            "Longitude": "\(AppDelegate.appDelegate.longitude ?? 0.0)",
            "Device-Token": TRUtilites.getOneSignleToken()*/
        ]
        
        if needUserToken {
            //headers["Authorization"] = "Bearer \(TRUtilites.getCurrentUserToken())"
        }
        
        debugPrint("➡️ REQUEST URL:", absoluteUrl)
        debugPrint("➡️ REQUEST HEADERS:", headers)
        debugPrint("➡️ REQUEST PARAMS:", parameters)
        
        guard NetConnection.isConnectedToNetwork() else {
            completionHandler(nil, "No Internet Connection", nil)
            return
        }
        
        AF.request(
            absoluteUrl,
            method: method,
            parameters: parameters,
            encoding: parameterEncoding,
            headers: headers
        )
        .responseData { response in
            
            let statusCode = response.response?.statusCode
            if let data = response.data {
                debugPrint("⬅️ RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "")
            }
            
            guard let data = response.data else {
                completionHandler(nil, "No data received", statusCode)
                return
            }
            
            do {
                // Try decoding success response first
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completionHandler(decoded, nil, statusCode)
            } catch {
                // If decoding fails, try decoding API error
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    completionHandler(nil, apiError.message, statusCode)
                } else {
                    // Fallback: raw decoding error
                    completionHandler(nil, "Decoding error: \(error.localizedDescription)", statusCode)
                }
            }
        }
    }
    
    func uploadMultipart(
        urlString: APIEndPoint,
        method: String = "POST",
        needUserToken: Bool = true,
        parameters: [String: String],
        files: [MultipartFile],
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        let absoluteUrl = BASE_URL + urlString.rawValue
        
        /*let deviceType = TRUtilites.deviceType()
        let deviceID = TRUtilites.deviceID()
        let latitude = "\(AppDelegate.appDelegate.latitude ?? 0.0)"
        let longitude = "\(AppDelegate.appDelegate.longitude ?? 0.0)"*/
        
        // ✅ DO NOT ADD Content-Type HERE
        var headers: [String: String] = [
            "Accept": "application/json",
            "Language": Language.shared.currentAppLang,
            /*"DeviceType": deviceType,
            "DeviceID": deviceID,
            "Latitude": latitude,
            "Longitude": longitude,
            "Device-Token": TRUtilites.getOneSignleToken()*/
        ]
        
        if needUserToken {
           // headers["Authorization"] = "Bearer \(TRUtilites.getCurrentUserToken())"
        }
        
        debugPrint("➡️ REQUEST URL:", absoluteUrl)
        debugPrint("➡️ REQUEST HEADERS:", headers)
        debugPrint("➡️ REQUEST PARAMS:", parameters)
        debugPrint("➡️ FILE COUNT:", files.count)
        
        guard let url = URL(string: absoluteUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 60
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // ✅ Apply headers
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        var body = Data()
        
        // MARK: - Text Parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // MARK: - Files
        for file in files {
            body.append("--\(boundary)\r\n")
            body.append(
                "Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.fileName)\"\r\n"
            )
            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("➡️ STATUS CODE:", httpResponse.statusCode)
            }
            
            DispatchQueue.main.async {
                completion(.success(data ?? Data()))
            }
            
        }.resume()
    }

    
    func showIndicaor() {
        SVProgressHUD.show()
    }
    
    func hideIndicator() {
        SVProgressHUD.dismiss()
    }
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
