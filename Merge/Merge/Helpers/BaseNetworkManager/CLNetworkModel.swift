//
//  CLNetworkModel.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

enum ErrorType : Int {
    case noNetwork = 1
    case dataError
    case notFound
    case internalServerError
}

class CLNetworkModel: NSObject {
    var requestURL: String?
    var requestMethod: String?
    var requestBody: String?
    var requestHeader: [String : String]?
    
    init(url : String, requestMethod_ : String){
        requestURL = url
        requestMethod = requestMethod_
        requestHeader = [String : String]()
        
        _ = requestHeader?.updateValue("application/json", forKey: "Content-Type")
        _ = requestHeader?.updateValue("53067a56941ff00369b726d450ef3bb9495c7224", forKey: "Authentication")
        print(requestURL!)
        print(requestMethod as? AnyObject)
        if let userToken = UserDefaults.standard.value(forKey: Constant.VariableNames.userToken){
            _ = requestHeader?.updateValue(userToken as! String, forKey: "Usertoken")
        }
//        if let _sessionToken = CCApplicationController.sharedInstance.cCAppTokens?.sessionToken{
//            _ = requestHeader?.updateValue(_sessionToken, forKey: "Session-Token")
//        }
    }
}
