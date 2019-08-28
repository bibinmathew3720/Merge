//
//  ArtistInfoManager.swift
//  Alwisal
//
//  Created by Appcircle on 17/06/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ArtistInfoManager: CLBaseService {
    func callingGetArtistInfoApi(with name:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForArtistInfo(artistName: name), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                success(ArtistInfoModel(info: jsonDict! as NSDictionary))
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    }
    
    func networkModelForArtistInfo(artistName:String)->CLNetworkModel{
        //let ParaMeter = "artist=\(artistName)&api_key=\(Constant.AppKeys.artistInfoKey)&format=json"
        let newsRequestModel = CLNetworkModel.init(url: BASE_URL+GETCURRENTSONGINFO, requestMethod_: "GET")
        return newsRequestModel
    }
}

class ArtistInfoModel:NSObject{
    var serverUrlString:String?
    var streamPath:String?
    var artistName: String?
    var title:String?
    var listenersCount: String?
    var peakListeners:String?
    var artistImage: String = ""
    var isFavorited:Bool = false
    var isLiked:Bool = false
    
    var playCount: String?
    
    init(info: NSDictionary) {
        print(info)
        if let _serverUrlString = info["serverurl"] as? String{
            serverUrlString = _serverUrlString
        }
        if let _artistName = info["artist"] as? String{
            artistName = _artistName
        }
        if let _title = info["title"] as? String{
            title = _title
        }
        if let _currentListeners = info["currentlisteners"] as? Int{
           listenersCount = "\(_currentListeners)"
        }
        if let _peakListeners = info["peaklisteners"] as? Int{
            peakListeners = "\(_peakListeners)"
        }
        if let _artistImage = info["image_path"] as? String{
            artistImage = _artistImage
        }
        if let favorite = info["favourite_status"] as? Int{
            if favorite == 1{
                isFavorited = true
            }
            else{
                isFavorited = false
            }
        }
        if let like = info["liked_status"] as? Int{
            if like == 1{
                isLiked = true
            }
            else{
                isLiked = false
            }
        }
        if let _streamPath = info["streampath"] as? String{
            streamPath = _streamPath
        }
        
        //playCount = info.value(forKeyPath: "artist.stats.playcount") as? String
//        if let images = info.value(forKeyPath: "artist.image") as? NSArray {
//            let imageData = images[2] as! NSDictionary
//            artistImage = imageData["#text"] as? String ?? "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            if artistImage == "" {
//                artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            }
//        }
//        else {
//            artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//        }
        
    }
    
    init(lastSong: SongHistoryModel) {
//        artistName = info.value(forKeyPath: "artist.name") as? String
//        listenersCount = info.value(forKeyPath: "artist.stats.listeners") as? String
//        playCount = info.value(forKeyPath: "artist.stats.playcount") as? String
//        if let images = info.value(forKeyPath: "artist.image") as? NSArray {
//            let imageData = images[1] as! NSDictionary
//            artistImage = imageData["#text"] as? String ?? "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            if artistImage == "" {
//                artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            }
//        }
//        else {
//            artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//        }
//        
    }
}
