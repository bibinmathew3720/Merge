//
//  NewsModuleManager.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/31/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class NewsModuleManager: CLBaseService {
    func callingGetNewsListApi(with pegeNumber:Int,noOfItem:Int, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForNews(pageNumber: pegeNumber, noOfItems: noOfItem), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveArrayResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict as NSArray?{
                    print(jdict)
                    // print(jsonDict)
                    success(self.getNewsModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForNews(pageNumber:Int,noOfItems:Int)->CLNetworkModel{
        let ParaMeter = "per_page=\(noOfItems)&page=\(pageNumber)"
        let newsRequestModel = CLNetworkModel.init(url: BASE_URL+GETNEWS+ParaMeter, requestMethod_: "GET")
        return newsRequestModel
    }
    
    func getNewsModel(dict:NSArray) -> Any? {
        let presenterResponseModel = NewsResponseModel.init(news: dict)
        return presenterResponseModel
    }
}

class NewsResponseModel:NSObject{
    var newsItems = [NewsModel]()
    init(news:NSArray) {
        if let _dict = news as? [[String:Any?]]{
            for item in _dict{
                newsItems.append(NewsModel.init(dict: item))
            }
        }
    }
}

class NewsModel:NSObject{
    var id:Int64 = 0
    var title:String = ""
    var content:String = ""
    var webViewContent:String = ""
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
                webViewContent = contentString
                var str = contentString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                str = str.replacingOccurrences(of: "&nbsp;", with: "")
                str = str.replacingOccurrences(of: "&#8220;", with: "")
                content = str
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
            if let fbUrlArray = value["facebook_link"] as? NSArray{
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
