//
//  LandingPageManager.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/22/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LandingPageManager: CLBaseService {
    func callingSongHistoryApi(success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForSongHistory(), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveArrayResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict as NSArray?{
                    print(jdict)
                    // print(jsonDict)
                    success(self.getSongHistoryModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    
    func networkModelForSongHistory()->CLNetworkModel{
        let presenterRequestModel = CLNetworkModel.init(url: BASE_URL+GETSONGHISTORY, requestMethod_: "GET")
        return presenterRequestModel
    }
    
    func getSongHistoryModel(dict:NSArray) -> Any? {
        let historyResponseModel = SongHistoryResponseModel.init(songs: dict)
        return historyResponseModel
    }
    
    func callingReactionApi(with body:String,smileyType:SmileyType, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        
        CLNetworkManager().initateWebRequest(networkModelForAddReaction(with:body, smilyType: smileyType), success: {
                 (resultData) in
                 let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
                 if error == nil {
                     if let jdict = jsonDict{
                         print(jdict)
                         // print(jsonDict)
                        
                        success(self.getAddReactionResponseModel(dict: jdict) as Any)
                         //success(self.getSongHistoryModel(dict: jdict) as Any)
                     }else{
                         failure(ErrorType.dataError)
                     }
                 }else{
                     failure(ErrorType.dataError)
                 }
                 
             }, failiure: {(error)-> () in failure(error)
                 
             })
    
    }
    
    func networkModelForAddReaction(with body:String, smilyType:SmileyType)->CLNetworkModel{
        var smileyUrl = ""
        if(smilyType == .SmileyTypeAngry){
            smileyUrl = SMILEY_TYPE_ANGRY_URL
        }else if(smilyType == .SmileyTypeSad){
           smileyUrl = SMILEY_TYPE_SAD_URL
        }else if(smilyType == .SmileyTypeNuetral){
           smileyUrl = SMILEY_TYPE_NUETRAL_URL
        }else if(smilyType == .SmileyTypeHappy){
           smileyUrl = SMILEY_TYPE_HAPPY_URL
        }else if(smilyType == .SmileyTypeLove){
           smileyUrl = SMILEY_TYPE_LOVE_URL
        }
        let requestModel = CLNetworkModel.init(url:BASE_URL + smileyUrl, requestMethod_: "POST")
        requestModel.requestBody = body
        return requestModel
    }
    
    func getAddReactionResponseModel(dict:[String : Any?]) -> Any? {
        let forModel = ReactionResponseModel.init(dict:dict)
        return forModel
    }
}

class SongHistoryResponseModel:NSObject{
    var historyItems = [SongHistoryModel]()
    init(songs:NSArray) {
        if let _dict = songs as? [[String:Any?]]{
            for item in _dict{
                historyItems.append(SongHistoryModel.init(dict: item))
            }
        }
    }
}

class SongHistoryModel:NSObject{
    var title:String = ""
    var artist:String = ""
    var imagePath:String = ""
    var songDate:CLongLong = 0
    var isFavorited:Bool = false
    var isLiked:Bool = false
    init(dict:[String:Any?]) {
        if let value = dict["title"] as? String{
            title = String(value)
        }
        if let value = dict["artist"] as? String{
            artist = String(value)
        }
        if let value = dict["image_path"] as? String{
            imagePath = value
        }
        if let value = dict["playedat"] as? CLongLong{
            songDate = value
        }
        if let favorite = dict["favourite_status"] as? Int{
            if favorite == 1{
                isFavorited = true
            }
            else{
                isFavorited = false
            }
            
        }
        if let like = dict["liked_status"] as? Int{
            if like == 1{
                isLiked = true
            }
            else{
                isLiked = false
            }
            
        }
    }
}
class ReactionResponseModel:NSObject{
    var error:Int = -1
    var favorite:Int = 0
    var isReactionAdded:Bool = false
    var errorMsg:String = ""
    
    init(dict:[String:Any?]) {
        if let value = dict["error"] as? Int{
            error = value
        }
        if let value = dict["favourite"] as? Int{
            favorite = value
        }
        if let value = dict["errorMsg"] as? String{
            errorMsg = value
        }
        
    }
    
}

class VotingRequestModel:NSObject{
    var title:String = ""
    
    func getRequestBody()->String{
        var requestBody = [String:AnyObject]()
        requestBody["title"] = title as AnyObject
        return AlwisalUtility.getJSONfrom(dictionary: requestBody)
    }
}
