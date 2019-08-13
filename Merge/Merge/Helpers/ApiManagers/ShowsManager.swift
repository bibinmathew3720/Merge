//
//  ShowsManager.swift
//  Merge
//
//  Created by Bibin Mathew on 8/13/19.
//  Copyright © 2019 SC. All rights reserved.
//

import UIKit

class ShowsManager: CLBaseService {
    func callingShowsListApi(with pegeNumber:Int,noOfItem:Int, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForShows(pageNumber: pegeNumber, noOfItems: noOfItem), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveArrayResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict as NSArray?{
                    print(jdict)
                    // print(jsonDict)
                    success(self.getShowsModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForShows(pageNumber:Int,noOfItems:Int)->CLNetworkModel{
        let ParaMeter = "per_page=\(noOfItems)&page=\(pageNumber)"
        let eventsRequestModel = CLNetworkModel.init(url: BASE_URL+GETSHOWS+ParaMeter, requestMethod_: "GET")
        return eventsRequestModel
    }
    
    func getShowsModel(dict:NSArray) -> Any? {
        let showsResponseModel = ShowsResponseModel.init(shows: dict)
        return showsResponseModel
    }
}

class ShowsResponseModel:NSObject{
    var showsItems = [ShowsModel]()
    init(shows:NSArray) {
        if let _dict = shows as? [[String:Any?]]{
            for item in _dict{
                showsItems.append(ShowsModel.init(dict: item))
            }
        }
    }
}

class ShowsModel:NSObject{
    var id:Int64 = 0
    var title:String = ""
    var content:String = ""
    var imagePath:String = ""
    var songDate:String = ""
    var fbLink:String = ""
    var twitterLink:String  = ""
    var statusMessage:String = ""
    var errorMessage:String = ""
    var errorCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["id"] as? Int64{
            id = value
        }
        if let value = dict["title"] as? AnyObject{
            if let titleString = value["rendered"] as? String{
                title = titleString
            }
        }
        if let value = dict["content"] as? AnyObject{
            if let contentString = value["rendered"] as? String{
                // let str = contentString.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                let string = contentString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                content = string
            }
        }
        if let value = dict["featured_image"] as? AnyObject{
            if let imageurl = value["home_ft"] as? String{
                imagePath = imageurl
            }
        }
        if let value = dict["date"] as? String{
            songDate = value
        }
        
        if let value = dict["custom_fields"] as? AnyObject{
            if let fbUrlArray = value["RJ_FACEBOOK_LINK"] as? NSArray{
                fbLink = fbUrlArray[0] as! String
            }
        }
        if let value = dict["custom_fields"] as? AnyObject{
            if let twitterUrlArray = value["twitter_link"] as? NSArray{
                twitterLink = twitterUrlArray[0] as! String
            }
        }
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
    }
}
