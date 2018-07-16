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
    case ArticlesPage
    case EventsPage
}

class PresentersVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PresentercCollectionCellDelegate {
   
    
    @IBOutlet weak var presenterCollectionView: UICollectionView!
    @IBOutlet weak var noItemsFoundLabel: UILabel!
    var presentersResponseModel:PresenterResponseModel?
    var newsResponseModel:NewsResponseModel?
    var articlesResponseModel:ArticlesResponseModel?
    var eventsResponseModel:EventsResponseModel?
    var pageType:PageType?
    
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
        else if(pageType == PageType.ArticlesPage){
            self.title = "Articles"
            getArticlesApi()
        }
        else if(pageType == PageType.EventsPage){
            self.title = "Events"
            getEventsApi()
        }
    }
    func backButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.presenterItems[tag])
        }
        if let _model = newsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.newsItems[tag])
        }
        if let _model = articlesResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.articleItems[tag])
        }
        if let _model = eventsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.eventsItems[tag])
        }
    }
    
    func twitterButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = articlesResponseModel{
            let selModel = _model.articleItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
    }
    
    func fbButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = articlesResponseModel{
            let selModel = _model.articleItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
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
        if(self.pageType == PageType.ArticlesPage){
            guard let _model = articlesResponseModel else {
                return 0
            }
            if(_model.articleItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.articleItems.count
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
        if let _model = articlesResponseModel{
            presenterCell.setArticleCell(model: _model.articleItems[indexPath.row])
        }
        if let _model = eventsResponseModel{
            presenterCell.setEventsCell(model: _model.eventsItems[indexPath.row])
        }
        presenterCell.delegate = self;
        return presenterCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            return CGSize(width: (collectionView.frame.size.width - 5)/2, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier:Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: "")
    }
    
    func  getPresentersApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PresenterModuleManager().callingPresentersListApi(with: 1, noOfItem: 10, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? PresenterResponseModel{
                self.presentersResponseModel = model
                self.presenterCollectionView.reloadData()
                
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
        NewsModuleManager().callingGetNewsListApi(with: 1, noOfItem: 10, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? NewsResponseModel{
                self.newsResponseModel = model
                self.presenterCollectionView.reloadData()
                
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
    
    func getArticlesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ArticlesManager().callingGetArticlesListApi(with: 1, noOfItem: 10, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ArticlesResponseModel{
                self.articlesResponseModel = model
                self.presenterCollectionView.reloadData()
                
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
        EventsManager().callingGetEventsListApi(with: 1, noOfItem: 10, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventsResponseModel{
                self.eventsResponseModel = model
                self.presenterCollectionView.reloadData()
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
