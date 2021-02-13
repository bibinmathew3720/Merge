//
//  LandingPageVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum SmileyType{
  case SmileyTypeAngry
  case SmileyTypeSad
  case SmileyTypeNuetral
  case SmileyTypeHappy
  case SmileyTypeLove
}

class LandingPageVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RecentlyPlayedCellDelegate {
    @IBOutlet weak var topLikeButton: UIButton!
    @IBOutlet weak var topFavoriteButton: UIButton!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var songerNameLabel: UILabel!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var smileyView: UIView!
    @IBOutlet weak var smileyViewSongNameLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    
    var newsPageIndex:Int = 1
    var noOfItems:Int = 10
    var isNewsApiCompleted:Bool = false
    var newsResponseModel:NewsResponseModel?
    var artistInfoModel:ArtistInfoModel?
    var currentSong:String?
    var bannerView: DFPBannerView!
    
    var voting = VotingRequestModel()
    var songHistoryTimer:Timer?
    
    override func initView() {
        super.initView()
        initialisation()
        addNavigationBarImage()
        initialisingAd()
        customisation()
    }
    
    //MARK: For getting Song History Updates
    
    func addingTimerForGettingSongHistory() {
        songHistoryTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    @objc func update() {
        self.getSongHistory(success: { (model) in
            if let model = model as? SongHistoryResponseModel{
                self.songHistoryResponseModel = model
                self.recentCollectionView.reloadData()
                if((model.historyItems.count)>0){
                    self.populateLastPlayedSongDetailsAtTop(lastSong: model.historyItems.first!)
                }
            }
        }) { (ErrorType) in
            
        }
    }
    
    func invalidateSongHistoryTimer(){
        if let _timer = self.songHistoryTimer{
            _timer.invalidate()
            self.songHistoryTimer = nil
        }
    }
    
    func addNavigationBarImage(){
        let image = UIImage(named: Constant.ImageNames.landingPageTitleImage)
        let imageView = UIImageView(image:image)
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func initialisingAd(){
        bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constant.adUnitIdString
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
        adImageView.addSubview(bannerView)
    }
    
    func initialisation(){
        //self.title = "Merge 104.8"
        self.voteButton.layer.borderColor = UIColor.white.cgColor
        self.voteButton.layer.borderWidth = 2
        self.tabBarItem.title = ""
        addRightNavBarIcon()
        addingLeftBarButton()
        //addShadowToAView(shadowView:singerImageView)
        callingInitialApis()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotifications(aNot:)), name: Notification.Name(Constant.Notifications.PlayerArtistInfo), object: nil)
    }
    
    func customisation(){
        //self.singerImageView.layer.borderWidth = 3
        //self.singerImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        invalidateSongHistoryTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setBlackgradientOnBottomOfView(gradientView: self.songImageView)
        addingTimerForGettingSongHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Collection View Datasources
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == recentCollectionView){
            guard let _model = songHistoryResponseModel else {
                return 0
            }
            return _model.historyItems.count
        }
        else if(collectionView == self.trendingCollectionView){
            guard let _model = newsResponseModel else {
                return 0
            }
            return _model.newsItems.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recentCollectionView{
            let recentCell:RecentlyPlayedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as! RecentlyPlayedCell
            recentCell.tag = indexPath.row;
            if let _model = songHistoryResponseModel{
                recentCell.setCell(to: _model.historyItems[indexPath.row])
            }
            recentCell.delegate = self;
            return recentCell
        }
        else{
            let trendingCell:TrendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TrendingCell
            trendingCell.tag = indexPath.row;
            //recentCell.delegate = self;
            if let _model = newsResponseModel{
                trendingCell.setCell(to: _model.newsItems[indexPath.row])
            }
            return trendingCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == self.recentCollectionView{
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.trendingCollectionView){
            if let _model = newsResponseModel{
                performSegue(withIdentifier: Constant.SegueIdentifiers.landingToPresenterDetail, sender: _model.newsItems[indexPath.row])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if collectionView == trendingCollectionView{
            if newsPageIndex>0 {
                if let newsResponse = self.newsResponseModel {
                    if self.isNewsApiCompleted{
                        if indexPath.row == newsResponse.newsItems.count - 1{
                            newsPageIndex = newsPageIndex + 1
                            getLatestNewsApi()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Button Actions
    
    @IBAction func voteButtonAction(_ sender: UIButton) {
        if(!sender.isSelected){
            self.smileyView.isHidden = false
            voting.artistName = locationLabel.text ?? ""
            voting.songName = songerNameLabel.text ?? ""
            self.smileyViewSongNameLabel.text = voting.songName
        }
    }
    
    @IBAction func smileyAction(_ sender: UIButton) {
        if(sender.tag == 1001){ //Angry
            callingReactionApi(smileyType: .SmileyTypeAngry)
        }else if(sender.tag == 1002){ //Sad
            callingReactionApi(smileyType: .SmileyTypeSad)
        }else if(sender.tag == 1003){ //Neutral
            callingReactionApi(smileyType: .SmileyTypeNuetral)
        }else if(sender.tag == 1004){ //Happy
            callingReactionApi(smileyType: .SmileyTypeHappy)
        }else if(sender.tag == 1005){ //Love
            callingReactionApi(smileyType: .SmileyTypeLove)
        }
    }
    
    @IBAction func closeButtonActionForSmileyView(_ sender: UIButton) {
        self.smileyView.isHidden = true;
    }
    
    @IBAction func favoriteBUttonAction(_ sender: UIButton) {
        if let currentSong = self.currentSong{
            if(self.isUserLoggedIn()){
                self.callingAddToFavoriteApiForCurrentSong(soName: currentSong,buttton:sender )
            }
        }
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if let currentSong = self.currentSong{
            if(self.isUserLoggedIn()){
                self.callingLikeApiForCurrentSong(soName: currentSong,button:sender )
            }
        }
    }
    
   
    @IBAction func filterButtonAction(_ sender: UIButton) {
        if let art = self.artistInfoModel{
            self.loadSongInfoView(artistInfo: art)
        }
        else{
            AlwisalUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message:Constant.Messages.InfoNotAvaliable, parentController: self, completion: { (okSuccess) in
                
            })
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: UIButton) {
        self.loadPlayListView(at: self.tabBarController!)
    }
    
    @IBAction func trendingVIewAllButtonAction(_ sender: UIButton){
        
    }
    
    //Api Calling
    
    
    func callingInitialApis(){
        let isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(isLoggedIn){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.callingGetUserProfilesApi(withCompletion: { (completion) in
                self.getSongHistory(success: { (model) in
                    if let model = model as? SongHistoryResponseModel{
                        self.songHistoryResponseModel = model
                        self.recentCollectionView.reloadData()
                        self.getLatestNewsApi()
                        
                        if((model.historyItems.count)>0){
                            self.populateLastPlayedSongDetailsAtTop(lastSong: model.historyItems.first!)
                        }
                    }
                }) { (ErrorType) in
                    
                }
            })
        }
        else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getSongHistory(success: { (model) in
                if let model = model as? SongHistoryResponseModel{
                    self.songHistoryResponseModel = model
                    self.recentCollectionView.reloadData()
                    self.getLatestNewsApi()
                    if((model.historyItems.count)>0){
                        self.populateLastPlayedSongDetailsAtTop(lastSong: model.historyItems.first!)
                    }
                }
            }) { (ErrorType) in

            }
        }
    }
    
    func populateLastPlayedSongDetailsAtTop(lastSong:SongHistoryModel){
        guard let modal = self.artistInfoModel else{
            self.currentSong = lastSong.artist+" - "+lastSong.title
            guard let encodedUrlstring =  lastSong.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
            self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
            self.songerNameLabel.text = lastSong.title
            self.checkWhetherCurrentSongVoted()
            self.locationLabel.text = lastSong.artist
            self.topFavoriteButton.isSelected = lastSong.isFavorited
            self.topLikeButton.isSelected = lastSong.isLiked
            return
        }
    }
    
    //MARK:- Notification Observer
    @objc func receiveNotifications(aNot: Notification) {
        self.currentSong = aNot.object as? String
        if let name = aNot.object as? String {
            let arr = name.components(separatedBy: " -")
            if arr.count > 0 {
                print(arr[0])
                getArtistInfo(name: arr[0])
            }
        }
    }
    
    func  callingAddToFavoriteApiForCurrentSong(soName:String,buttton:UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBodyForCurrentSong(songName: soName), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    buttton.isSelected = model.favorite
                    //self.landingCollectionView.reloadData()
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getFavoriteRequestBodyForCurrentSong(songName:String)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songName, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    
    //MARK : Calling Like Api For Current Song
    
    func  callingLikeApiForCurrentSong(soName:String,button:UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBodyForCurrentSong(songName: soName), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    button.isSelected = model.liked
                    //self.landingCollectionView.reloadData()
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getLikeRequestBodyForCurrentSong(songName:String)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songName, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    func callingReactionApi(smileyType:SmileyType){
           MBProgressHUD.showAdded(to: self.view, animated: true)
           LandingPageManager().callingReactionApi(with: voting.getRequestBody(),smileyType:smileyType, success: { (model) in
               MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ReactionResponseModel{
                if model.error == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMsg, parentController: self)
                }
                else{
                    //if model.isReactionAdded == true{
                    self.smileyView.isHidden = true
                    Voting.saveVotedData(votingModel: self.voting)
                    self.checkWhetherCurrentSongVoted()
                    //}
                }
            }
               
           }) { (errorType) in
               MBProgressHUD.hide(for: self.view, animated: true)
               if(errorType == .noNetwork){
                   AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
               }
               else{
                   AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
               }
           }
       }
    
    func checkWhetherCurrentSongVoted(){
        if (Voting.getVotedSongWithSongName(songName:songerNameLabel.text ?? "") != nil){
            voteButton.isSelected = true
        }else{
            voteButton.isSelected = false
        }
    }
    
    //MARK:- Webservice Calls
    
    func getArtistInfo(name: String) {
        ArtistInfoManager().callingGetArtistInfoApi(with: name, success: { (model) in
            let artistInfo = model as! ArtistInfoModel
            self.artistInfoModel = artistInfo
            self.songerNameLabel.text = name
            self.checkWhetherCurrentSongVoted()
            self.nowPlayingLabel.isHidden = false
            if let _artistInfo = self.artistInfoModel{
                if let _title = _artistInfo.title{
                    self.songerNameLabel.text = _title
                    self.checkWhetherCurrentSongVoted()
                }
                self.locationLabel.text = _artistInfo.artistName
                self.topLikeButton.isSelected = _artistInfo.isLiked
                self.topFavoriteButton.isSelected = _artistInfo.isFavorited
                DispatchQueue.main.async {
                    guard let encodedUrlstring =  _artistInfo.artistImage.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
                    self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
                }
                if let _songInfoView = self.songInfoView{
                    _songInfoView.populateArtistInfo(artiInfo: _artistInfo)
                }
            }
            
            
        }) { (error) in
            
        }
    }
    
    //MARK: Get User Profiles
    
    func callingGetUserProfilesApi(withCompletion:@escaping (Bool)-> ()){
        UserModuleManager().callingGetUserProfilesApi(with: "", success: { (model) in
            if let model = model as? AlwisalUserProfileResponseModel{
                //UserDefaults.standard.set(model.firstName+" "+model.lastName, forKey: Constant.VariableNames.userName)
                UserDefaults.standard.set(model.userEmail, forKey: Constant.VariableNames.userName)
                UserDefaults.standard.set(model.id, forKey: Constant.VariableNames.userId)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
                withCompletion(true)
                
            }
        }) {(ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            withCompletion(false)
        }
    }
    
    func getLatestNewsApi(){
        isNewsApiCompleted = false
        if self.newsPageIndex != 1{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        NewsModuleManager().callingGetNewsListApi(with: self.newsPageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? NewsResponseModel{
                if (self.newsPageIndex == 1){
                    self.newsResponseModel = nil
                }
                if let newsRespone = self.newsResponseModel {
                    newsRespone.newsItems.append(contentsOf: model.newsItems)
                    self.trendingCollectionView.reloadData()
                }
                else{
                    self.newsResponseModel = model
                }
                self.trendingCollectionView.reloadData()
                if model.newsItems.count<self.noOfItems {
                    self.newsPageIndex = -1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  self.isNewsApiCompleted = true
                }
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isNewsApiCompleted = true
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func likeButtonActionDelegateWithTag(tag: NSInteger) {
        if(isUserLoggedIn()){
            if let _model = songHistoryResponseModel{
                self.callingLikeApi(songHistory: _model.historyItems[tag])
            }
        }
    }
    
    func favoriteButtonActionDelegateWithTag(tag: NSInteger) {
        if(isUserLoggedIn()){
            if let _model = songHistoryResponseModel{
                self.callingAddToFavoriteApi(songHistory: _model.historyItems[tag])
            }
        }
        
    }
    //MARK : Calling Favorite Api
    
    func  callingAddToFavoriteApi(songHistory:SongHistoryModel){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBody(songHistoryModel: songHistory), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    songHistory.isFavorited = model.favorite
                    self.recentCollectionView.reloadData()
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getFavoriteRequestBody(songHistoryModel:SongHistoryModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songHistoryModel.artist+" - "+songHistoryModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK : Calling Like Api
    
    func  callingLikeApi(songHistory:SongHistoryModel){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBody(songHistoryModel: songHistory), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    songHistory.isLiked = model.liked
                    self.recentCollectionView.reloadData()
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getLikeRequestBody(songHistoryModel:SongHistoryModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songHistoryModel.artist+" - "+songHistoryModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK: Prepare Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constant.SegueIdentifiers.landingToNewsList){
            let presentersVC = segue.destination as! PresentersVC
            presentersVC.pageType = PageType.NewsPage
        }
        else if(segue.identifier == Constant.SegueIdentifiers.landingToPresenterDetail){
            let presentDetail = segue.destination as! PresenterDetailVC
            presentDetail.newsModel = sender as? NewsModel
            presentDetail.hidesBottomBarWhenPushed = true
            presentDetail.newsResponseModel = self.newsResponseModel
            presentDetail.pageType = PageType.NewsPage
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
