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
    
    func request(
        method: HTTPMethod,
        url: APIEndPoint,
        parameters: Parameters = [:],
        pathComponent: String = "",
        needUserToken: Bool = true,
        completionHandler:@escaping (NSDictionary?, Error?, Int?) -> Void)
    {
        
        let absoluteUrl = BASE_URL + "/" + url.rawValue + pathComponent
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if needUserToken {
            headers["Authorization"] = "Bearer"
        }
        
        if NetConnection.isConnectedToNetwork() == true {
            AF.request(
                absoluteUrl,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers).responseJSON { (response) in
                    switch(response.result) {
                        
                    case .success:
                        if response.value != nil{
                            if let responseDict = ((response.value as AnyObject) as? NSDictionary) {
                                completionHandler(responseDict, nil, response.response?.statusCode)
                            }
                        }
                        
                    case .failure:
                        print(response.error!)
                        print("Http Status Code: \(String(describing: response.response?.statusCode))")
                        completionHandler(nil, response.error, response.response?.statusCode )
                    }
                }
        } else {
            print("No Network Found!")
            pushNetworkErrorVC()
            SVProgressHUD.dismiss()
        }
        
    }
    
}
