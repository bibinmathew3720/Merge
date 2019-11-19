//
//  PresentersVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

enum PageType{
    case PresenterPage
    case NewsPage
    case EventsPage
    case ShowsPage
}

class PresentersVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PresentercCollectionCellDelegate {
   
    
    @IBOutlet weak var presenterCollectionView: UICollectionView!
    @IBOutlet weak var noItemsFoundLabel: UILabel!
    var presentersResponseModel:PresenterResponseModel?
    var newsResponseModel:NewsResponseModel?
    var eventsResponseModel:EventsResponseModel?
    var showsResponseModel:ShowsResponseModel?
    var pageType:PageType?
    var pageIndex:Int = 1
    var noOfItems:Int = 10
    
    override func initView() {
        super.initView()
        initialisation()
        customisation()
    }
    
    func initialisation(){
        addingLeftBarButton()
        addRightNavBarIcon()
    }
    
    func customisation(){
        if (pageType == PageType.PresenterPage){
            self.title = "Presenters"
            getPresentersApi()
        }
        else if(pageType == PageType.NewsPage){
            self.title = "News"
            getLatestNewsApi()
        }
        else if(pageType == PageType.EventsPage){
            self.title = "Events"
            getEventsApi()
        }
        else if(pageType == PageType.ShowsPage){
            self.title = "Shows"
            getShowsApi()
        }
    }
    func backButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.presenterItems[tag])
        }
        if let _model = newsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.newsItems[tag])
        }
        if let _model = eventsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.eventsItems[tag])
        }
        if let _model = showsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.showsItems[tag])
        }
    }
    
    func twitterButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (Constant.twitterSharingLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
             self.shareTextOnTwitter(content: selModel.title)
            //loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = showsResponseModel{
            let selModel = _model.showsItems[tag]
            loadWebUrl(webUrlString: (Constant.twitterSharingLink))
        }
    }
    
    func fbButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (Constant.fbSharingLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
             self.shareTextOnFacebook(content: selModel.title)
            //loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = showsResponseModel{
            let selModel = _model.showsItems[tag]
            loadWebUrl(webUrlString: (Constant.fbSharingLink))
        }
    }
    
    //MARK:- Collection View Datasources
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.pageType == PageType.PresenterPage){
            guard let _model = presentersResponseModel else {
                return 0
            }
            if(_model.presenterItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.presenterItems.count
        }
        if(self.pageType == PageType.NewsPage){
            guard let _model = newsResponseModel else {
                return 0
            }
            if(_model.newsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.newsItems.count
        }
        if(self.pageType == PageType.EventsPage){
            guard let _model = eventsResponseModel else {
                return 0
            }
            if(_model.eventsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.eventsItems.count
        }
        if(self.pageType == PageType.ShowsPage){
            guard let _model = showsResponseModel else {
                return 0
            }
            if(_model.showsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.showsItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presenterCell:PresenterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenterCell", for: indexPath) as! PresenterCell
        presenterCell.tag = indexPath.row;
        if let _model = presentersResponseModel{
            presenterCell.setPresenterCell(to: _model.presenterItems[indexPath.row])
        }
        if let _model = newsResponseModel{
            presenterCell.setNewsCell(model: _model.newsItems[indexPath.row])
        }
        if let _model = eventsResponseModel{
            presenterCell.setEventsCell(model: _model.eventsItems[indexPath.row])
        }
        if let _model = showsResponseModel{
            presenterCell.setshowsCell(model: _model.showsItems[indexPath.row])
        }
        presenterCell.delegate = self;
        return presenterCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            return CGSize(width: (collectionView.frame.size.width - 5)/2, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _model = presentersResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.presenterItems[indexPath.row])
        }
        if let _model = newsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.newsItems[indexPath.row])
        }
        if let _model = eventsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.eventsItems[indexPath.row])
        }
        if let _model = showsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.showsItems[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if pageIndex>0 {
            if (pageType == PageType.PresenterPage){
                if let preResponse = self.presentersResponseModel {
                    if indexPath.row == preResponse.presenterItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getPresentersApi()
                    }
                }
            }
            else if (pageType == PageType.EventsPage) {
                if let eventsResponse = self.eventsResponseModel {
                    if indexPath.row == eventsResponse.eventsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getEventsApi()
                    }
                }
            }
            else if (pageType == PageType.NewsPage) {
                if let newsResponse = self.newsResponseModel {
                    if indexPath.row == newsResponse.newsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getLatestNewsApi()
                    }
                }
            }
            else if (pageType == PageType.ShowsPage) {
                if let showsResponse = self.showsResponseModel {
                    if indexPath.row == showsResponse.showsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getShowsApi()
                    }
                }
            }
        }
    }
    
    func  getPresentersApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PresenterModuleManager().callingPresentersListApi(with: pageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? PresenterResponseModel{
                if let presentsResponse = self.presentersResponseModel {
                    presentsResponse.presenterItems.append(contentsOf: model.presenterItems)
                }
                else{
                    self.presentersResponseModel = model
                }
                self.presenterCollectionView.reloadData()
                if model.presenterItems.count<self.noOfItems {
                    self.pageIndex = -1
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
    
    func getLatestNewsApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NewsModuleManager().callingGetNewsListApi(with: pageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? NewsResponseModel{
                if let newsRespone = self.newsResponseModel {
                   newsRespone.newsItems.append(contentsOf: model.newsItems)
                }
                else{
                    self.newsResponseModel = model
                }
                self.presenterCollectionView.reloadData()
                if model.newsItems.count<self.noOfItems {
                    self.pageIndex = -1
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
    
    
    func getEventsApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        EventsManager().callingGetEventsListApi(with: pageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventsResponseModel{
                if let eventsResponse = self.eventsResponseModel {
                    eventsResponse.eventsItems.append(contentsOf: model.eventsItems)
                }
                else{
                    self.eventsResponseModel = model
                }
                self.presenterCollectionView.reloadData()
                if model.eventsItems.count<self.noOfItems {
                    self.pageIndex = -1
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
    
    func getShowsApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ShowsManager().callingShowsListApi(with: pageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ShowsResponseModel{
                if let showsResponse = self.showsResponseModel {
                    showsResponse.showsItems.append(contentsOf: model.showsItems)
                }
                else{
                    self.showsResponseModel = model
                }
                self.presenterCollectionView.reloadData()
                if model.showsItems.count<self.noOfItems {
                    self.pageIndex = -1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constant.SegueIdentifiers.presenterToPresenterDetailSegue){
            let presentDetail = segue.destination as! PresenterDetailVC
            presentDetail.hidesBottomBarWhenPushed = true
            if let _model = presentersResponseModel{
                presentDetail.presentersModel = sender as? PresenterModel
                presentDetail.presenterResponseModel = _model
                presentDetail.pageType = PageType.PresenterPage
            }
            if let _model = newsResponseModel{
                presentDetail.newsModel = sender as? NewsModel
                presentDetail.newsResponseModel = _model
                presentDetail.pageType = PageType.NewsPage
            }
            if let _model = eventsResponseModel{
                presentDetail.eventsModel = sender as? EventsModel
                presentDetail.eventsResponseModel = _model
                presentDetail.pageType = PageType.EventsPage
               
            }
            if let _model = showsResponseModel{
                presentDetail.showsModel = sender as? ShowsModel
                presentDetail.showsResponseModel = _model
                presentDetail.pageType = PageType.ShowsPage
                
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
