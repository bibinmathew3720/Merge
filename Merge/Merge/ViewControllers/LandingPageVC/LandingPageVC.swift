//
//  LandingPageVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

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
    
    var newsResponseModel:NewsResponseModel?
    var artistInfoModel:ArtistInfoModel?
    var currentSong:String?
    
    override func initView() {
        super.initView()
        initialisation()
        customisation()
    }
    
    func initialisation(){
        self.title = "Merge 104.8"
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
        self.setBlackgradientOnBottomOfView(gradientView: self.songImageView)
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
    
    //MARK: Button Actions
    
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
            self.locationLabel.text = lastSong.artist
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
    
    //MARK:- Webservice Calls
    
    func getArtistInfo(name: String) {
        ArtistInfoManager().callingGetArtistInfoApi(with: name, success: { (model) in
            let artistInfo = model as! ArtistInfoModel
            self.artistInfoModel = artistInfo
            self.songerNameLabel.text = name
            self.nowPlayingLabel.isHidden = false
            self.topLikeButton.isSelected = false
            self.topFavoriteButton.isSelected = false
            self.locationLabel.text = self.artistInfoModel?.artistName
            DispatchQueue.main.async {
                 guard let encodedUrlstring =  artistInfo.artistImage!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
                self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
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
        NewsModuleManager().callingGetNewsListApi(with: 1, noOfItem: 10, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? NewsResponseModel{
                self.newsResponseModel = model
                self.trendingCollectionView.reloadData()
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
