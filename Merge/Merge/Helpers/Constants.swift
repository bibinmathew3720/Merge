//
//  Constants.swift
//  Alwisal
//
//  Created by Bibin Mathew on 4/30/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
struct Constant{
    static let AppName = "Merge"
    static let WhatsAppNumber = "+96871701048"
    struct Notifications{
        static let RootSettingNotification = "com.alwisal.initNotification"
        static let UserProfileNotification = "com.alwisal.userProfileNotification"
        static let PlayerArtistInfo = "com.alwisal.artistInfoNotification"
    }
    struct VariableNames {
        static let isLoogedIn = "isLoggedIn"
        static let userToken = "userToken"
        static let userName = "userName"
        static let userImage = "userImage"
        static let userId = "userId"
    }
    
    struct Colors {
        static let commonGrayColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        static let commonGreenColor = UIColor(red:0.13, green:0.72, blue:0.82, alpha:1.0) //20b7d2
    }
    
    struct ErrorMessages {
        static let noNetworkMessage = "No Internet connection. Please check your connection settings and try again!"
        static let serverErrorMessamge = "Cannot connect to server, please try again."
    }
    
    struct ImageNames {
        static let placeholderImage = "placeholder"
        static let placeholderArtistInfoImage = "songDefaultImage"
        static let profilePlaceholderImage = "placeholder"
        struct tabImages{
            static let soundIcon = "soundIcon"
            static let muteIcon = "muteIcon"
            static let playIcon = "playIcon"
            static let pauseIcon = "pauseIcon"
        }
    }
    
    struct SegueIdentifiers {
        static let presenterToPresenterDetailSegue = "presenterToDetail"
        static let landingToNewsList = "landingToNewsList"
        static let landingToPresenterDetail = "landingToPrsenterDetails"
    }
    struct AppKeys {
        static let googleClientID = "338103195232-0l3102r119pifji42ge14km2qhm14teh.apps.googleusercontent.com"
        static let twitterConsumerKey = "x0oIx3qZN9PLTxfXxnxbjB7jA"
        static let twitterConsumerSecret = "NtKfWYpxSyqS2HMx1YBtLrOoAuRZZ4zswe8joewEmrupPPny8E"
        static let artistInfoKey = "665b8ff2830d494379dbce3fb3b218a9"
    }
    
    struct Messages {
        static let yesString = "YES"
        static let noString = "NO"
        static let okString = "Ok"
        static let cancelString = "Cancel"
        static let logInMessage = "Please sign in to use this feature"
        static let InfoNotAvaliable = "Information not available"
        static let logoutMessage = "Do you want to logout?"
        
    }
    static let AuthenticationToken = "53067a56941ff00369b726d450ef3bb9495c7224"
    
    static let audioStreamingUrlString = "http://uk7.internet-radio.com:8040"
    static let facebookLink = "https://www.facebook.com/radiomerge"
    static let twitterLink = "https://twitter.com/radiomerge"
    static let contactUsUrlString = "http://test.radiomerge.fm/contact-us?app=1"
    
    static let sharingUrlString = "http://alwisal.radio.net/"
}

