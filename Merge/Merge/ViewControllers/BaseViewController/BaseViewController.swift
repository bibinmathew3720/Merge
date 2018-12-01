//
//  BaseViewController.swift
//  Alwisal
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import MBProgressHUD
class BaseViewController: UIViewController,UITabBarControllerDelegate,PlayListViewDelegate,SongInfoViewDelegate {
    var playListView:PlaylistView!
    var songInfoView:SongInfoView!
    var blurEffectView:UIVisualEffectView?
    var songHistoryResponseModel:SongHistoryResponseModel?
    
    var leftButton:UIButton?
    var rightButton:UIButton?
    
    var rightBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if AlwisalPlayer.defaultPlayer.player == nil {
            AlwisalPlayer.defaultPlayer.initiateAVPlayer()
        }
    }
    func initView(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.delegate = self
    }
    
    //MARK: Adding Navigation Bar Buttons
    
    func addingLeftBarButton(){
        self.leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.leftButton?.addTarget(self, action: #selector(leftNavButtonAction), for: .touchUpInside)
        self.leftButton?.setImage(UIImage.init(named: "hamburgerIcon"), for: UIControlState.normal)
        var leftBarButton = UIBarButtonItem()
        leftBarButton = UIBarButtonItem.init(customView: self.leftButton!)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func leftNavButtonAction(){
        self.slideMenuController()?.openLeft()
    }
    
    func addRightNavBarIcon(){
        self.rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.rightButton?.addTarget(self, action: #selector(rightNavButtonAction), for: .touchUpInside)
        self.rightButton?.setImage(UIImage.init(named: "homeIcon"), for: UIControlState.normal)
        var rightBarButton = UIBarButtonItem()
        rightBarButton = UIBarButtonItem.init(customView: self.rightButton!)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightNavButtonAction(){
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
    }
    
    func setBlackgradientOnBottomOfView(gradientView:UIView){
        let layrs = gradientView.layer.sublayers
        if(layrs != nil){
            for layer in gradientView.layer.sublayers! {
                if layer.name == "1000" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "1000"
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.3).cgColor,UIColor.black.withAlphaComponent(0.6).cgColor,UIColor.black.withAlphaComponent(1.0).cgColor]
        
        gradientView.layer.addSublayer(gradientLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Navigation View Delegate
    
    func infoButtonActionDelegate() {
        let naControllerAtIndex0 = self.tabBarController?.viewControllers![0] as! UINavigationController
        let selTabBarCntlrNavItem = self.tabBarController?.viewControllers?.first as! UINavigationController
//        if(selTabBarCntlrNavItem.viewControllers.first == naControllerAtIndex0.viewControllers.first){
//            self.tabBarController?.selectedIndex = 2 // Landingpage
//        }
//        else{
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
        if self.tabBarController?.selectedIndex == 0{
            self.tabBarController?.selectedIndex = 2
        }
        else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func hamburgerActionDelegate() {
        
        self.slideMenuController()?.openRight()
    }
    
    // MARK - Tabbar controller delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selTabBarCntlr = viewController as! UINavigationController
        let naControllerAtIndex0 = tabBarController.viewControllers![0] as! UINavigationController
         let naControllerAtIndex1 = tabBarController.viewControllers![1] as! UINavigationController
        let naControllerAtIndex2 = tabBarController.viewControllers![2] as! UINavigationController
        let naControllerAtIndex3 = tabBarController.viewControllers![3] as! UINavigationController
         let naControllerAtIndex4 = tabBarController.viewControllers![4] as! UINavigationController
        
        if(selTabBarCntlr.viewControllers.first == naControllerAtIndex0.viewControllers.first){
            if(isUserLoggedIn()){
                selTabBarCntlr.popToRootViewController(animated: true)
                return true
            }
            return false
        }
        if(selTabBarCntlr.viewControllers.first == naControllerAtIndex1.viewControllers.first){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getSongHistory(success: { (model) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let model = model as? SongHistoryResponseModel{
                    self.loadPlayListView(at: tabBarController)
                }
            }) { (ErrorType) in
                
            }
           
            return false
        }

        if(selTabBarCntlr.viewControllers.first == naControllerAtIndex2.viewControllers.first ){
            let thirdTabItem = tabBarController.tabBar.items![2]
            let playImage = UIImage(named: Constant.ImageNames.tabImages.playIcon)
            let tabImage = thirdTabItem.selectedImage
            let data1: NSData = UIImagePNGRepresentation(playImage!)! as NSData
            let data2: NSData = UIImagePNGRepresentation(tabImage!)! as NSData
            if(data1.isEqual(to: data2 as Data)){
                thirdTabItem.selectedImage = UIImage(named:Constant.ImageNames.tabImages.pauseIcon)! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                thirdTabItem.image = UIImage(named:Constant.ImageNames.tabImages.pauseIcon)! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                AlwisalPlayer.defaultPlayer.play()
                
            }
            else{
                thirdTabItem.selectedImage = playImage! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                 thirdTabItem.image = playImage! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                AlwisalPlayer.defaultPlayer.pause()
                
            }
            return false
        }
        else if(selTabBarCntlr.viewControllers.first == naControllerAtIndex3.viewControllers.first){
            let fourthTabItem = tabBarController.tabBar.items![3]
            let soundImage = UIImage(named: Constant.ImageNames.tabImages.muteIcon)
            let tabImage = fourthTabItem.image
            let data1: NSData = UIImagePNGRepresentation(soundImage!)! as NSData
            let data2: NSData = UIImagePNGRepresentation(tabImage!)! as NSData
            if(data1.isEqual(to: data2 as Data)){
                if(AlwisalPlayer.defaultPlayer.mute()){
                    fourthTabItem.image = UIImage(named:Constant.ImageNames.tabImages.soundIcon)! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                    fourthTabItem.title =  "VOLUME"
                }
            }
            else{
                if(AlwisalPlayer.defaultPlayer.unmute()){
                    fourthTabItem.image = UIImage(named:Constant.ImageNames.tabImages.muteIcon)! .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                    fourthTabItem.title = "MUTE"
                }
            }
            
            
            return false
        }
        else if(selTabBarCntlr.viewControllers.first == naControllerAtIndex4.viewControllers.first){
            showSharingController()
            return false
        }
        return true
    }
    
    
    func loadPlayListView(at tabBarCntrolr:UITabBarController){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView?.frame = view.bounds
        self.blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBarCntrolr.view.addSubview(blurEffectView!)
        playListView = (Bundle.main.loadNibNamed("PlaylistView", owner: self, options: nil))?.first as! PlaylistView
        playListView.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        playListView.delegate = self
        playListView.backArrowImageView.isHidden = true
        if let historyModel = self.songHistoryResponseModel{
            playListView.populateSongHistory(songHistory: historyModel)
        }
        tabBarCntrolr.view.addSubview(playListView)
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.playListView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height+50)
        }, completion: { (isCompleted:Bool) in
            self.playListView.backArrowImageView.isHidden = false
            self.view.bringSubview(toFront: self.playListView)
        })
    }
    
    func loadSongInfoView(artistInfo:ArtistInfoModel){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView?.frame = view.bounds
        self.blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tabBarController?.view.addSubview(blurEffectView!)
        songInfoView = (Bundle.main.loadNibNamed("SongInfoView", owner: self, options: nil))?.first as! SongInfoView
        songInfoView.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        songInfoView.delegate = self
        songInfoView.songInfoBackImage.isHidden = true
        songInfoView.populateArtistInfo(artiInfo: artistInfo)
        self.tabBarController?.view.addSubview(songInfoView)
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.songInfoView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height+40)
        }, completion: { (isCompleted:Bool) in
            self.songInfoView.songInfoBackImage.isHidden = false
            self.view.bringSubview(toFront: self.songInfoView)
        })
    }
    
    //MARK: PlayList View Delegates
    
    func backButtonActionDelegate(){
        
        if let blurEffectView = self.blurEffectView {
            blurEffectView.removeFromSuperview()
        }
        blurEffectView = nil
        
        self.playListView.frame = self.view.frame
        self.playListView.backArrowImageView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.playListView.frame = CGRect.init(x: 0, y: (self.view.frame.size.height), width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: { (isCompleted:Bool) in
            self.playListView.removeFromSuperview()
            
        })
    }
    
    //MARK: SongInfo View Dlegate
    
    func backButtonActionDelegateFromSongInfo(){
        if let blurEffectView = self.blurEffectView {
            blurEffectView.removeFromSuperview()
        }
        blurEffectView = nil
        
        self.songInfoView.frame = self.view.frame
        self.songInfoView.songInfoBackImage.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.songInfoView.frame = CGRect.init(x: 0, y: (self.view.frame.size.height), width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: { (isCompleted:Bool) in
            self.songInfoView.removeFromSuperview()
            
        })
    }
    

    
    func  getSongHistory(success:@escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        LandingPageManager().callingSongHistoryApi(success: { (model) in
            if let model = model as? SongHistoryResponseModel{
                self.songHistoryResponseModel = model
                if let playList = self.playListView{
                    playList.populateSongHistory(songHistory: model)
                }
                success(model)
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
    
    //MARK: Sharing Via Social Media
    
    func showSharingController(){
        // set up activity view controller
        let objectsToShare:URL = URL(string: Constant.sharingUrlString)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        DispatchQueue.main.async { () -> Void in
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func loadWebUrl(webUrlString:String) -> () {
        if let url = URL(string: webUrlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func isUserLoggedIn()->Bool{
        let isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(!isLoggedIn){
            AlwisalUtility.showAlertWithOkOrCancel(_title: Constant.AppName, viewController: self, messageString: Constant.Messages.logInMessage) { (success) in
                if(success){
                    self.navigateToLogInPage()
                }
            }
        }
        return isLoggedIn
    }
    
    func navigateToLogInPage(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let firstLoginVC = storyBoard.instantiateViewController(withIdentifier: "FirstLoginVC")
        let logInNavController = UINavigationController.init(rootViewController: firstLoginVC)
        self.slideMenuController()?.closeRight()
        DispatchQueue.main.async { () -> Void in
            self.present(logInNavController, animated: true)
        }
    }
    
    func processAfterLogout(){
        UserDefaults.standard.set(false, forKey: Constant.VariableNames.isLoogedIn)
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
    }
    
    //MARK: Adding Shadow View
    
    func addShadowToAView(shadowView:UIView){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 5
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 5
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
