//
//  LandingPageVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LandingPageVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        self.title = "Radio Merge"
        self.tabBarItem.title = ""
        addRightNavBarIcon()
        addingLeftBarButton()
        addShadowToAView(shadowView:singerImageView)
        callingInitialApis()
    }
    
    func customisation(){
        self.singerImageView.layer.borderWidth = 3
        self.singerImageView.layer.borderColor = UIColor.white.cgColor
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
      
            return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recentCollectionView{
            let recentCell:RecentlyPlayedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as! RecentlyPlayedCell
            recentCell.tag = indexPath.row;
            //recentCell.delegate = self;
            return recentCell
        }
        else{
            let trendingCell:TrendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TrendingCell
            trendingCell.tag = indexPath.row;
            //recentCell.delegate = self;
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
        
    }
    
    //MARK: Button Actions
    
    @IBAction func favoriteBUttonAction(_ sender: UIButton) {
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func viewAllButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func trendingVIewAllButtonAction(_ sender: UIButton){
        
    }
    
    //Api Calling
    
    
    func callingInitialApis(){
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotifications(aNot:)), name: Notification.Name(Constant.Notifications.PlayerArtistInfo), object: nil)
        
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
            self.getLatestNewsApi()
//            self.getSongHistory(success: { (model) in
//                if let model = model as? SongHistoryResponseModel{
//                    self.songHistoryResponseModel = model
//                    self.recentCollectionView.reloadData()
//                    self.getLatestNewsApi()
//                }
//            }) { (ErrorType) in
//
//            }
        }
    }
    
    func populateLastPlayedSongDetailsAtTop(lastSong:SongHistoryModel){
        guard let modal = self.artistInfoModel else{
            self.currentSong = lastSong.artist+" - "+lastSong.title
            self.songImageView.sd_setImage(with: URL(string: lastSong.imagePath), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
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
    
    //MARK:- Webservice Calls
    
    func getArtistInfo(name: String) {
        ArtistInfoManager().callingGetArtistInfoApi(with: name, success: { (model) in
            let artistInfo = model as! ArtistInfoModel
            self.artistInfoModel = artistInfo
            self.songerNameLabel.text = name
            self.locationLabel.text = self.artistInfoModel?.artistName
            DispatchQueue.main.async {
                self.songImageView.sd_setImage(with: URL(string: artistInfo.artistImage!), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
