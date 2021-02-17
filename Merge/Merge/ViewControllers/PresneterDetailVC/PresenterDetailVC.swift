//
//  PresenterDetailVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class PresenterDetailVC: BaseViewController {
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var presenterNameLabel: UILabel!
    @IBOutlet weak var backListButton: UIButton!
    @IBOutlet weak var nextPresenterButton: UIButton!
    @IBOutlet weak var nextPresenterImageView: UIImageView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var newsDetailWebView: WKWebView!
    
    var presenterResponseModel:PresenterResponseModel?
    var newsResponseModel:NewsResponseModel?
    var eventsResponseModel:EventsResponseModel?
    var showsResponseModel:ShowsResponseModel?
    
    var presentersModel:PresenterModel?
    var newsModel:NewsModel?
    var eventsModel:EventsModel?
    var showsModel:ShowsModel?
    var pageType:PageType?
    var selectedIndex:Int?
    var bannerView: DFPBannerView!
    let appendingString = "<style type=\"text/css\">.embed-youtube {overflow: hidden;padding-bottom: 56.25%;position: relative;height: 0;}.embed-youtube iframe {left: 0;top: 0;height: 100%;width: 100%;position: absolute;}</style>"
    override func initView() {
        super.initView()
        initialisation()
        initialisingAd()
        populateDetails()
    }
    
    func initialisingAd(){
        bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constant.adUnitIdString
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
       // bannerView.delegate = self
        adImageView.addSubview(bannerView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false
        super.viewDidDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let _detailWebView = newsDetailWebView{
            _detailWebView.removeFromSuperview()
        }
    }
    
    func populateDetails(){
        self.nextPresenterButton.isHidden = false
        self.nextPresenterImageView.isHidden = false
        if let _model = presentersModel{
            self.title = "Presenters"
            self.nextPresenterButton.setTitle("NEXT PRESENTER", for: UIControlState.normal)
            self.populatePresenterData(presenter: _model)
            self.selectedIndex = self.presenterResponseModel?.presenterItems.index(of: _model)
            if (self.selectedIndex! + 1) == self.presenterResponseModel?.presenterItems.count{
                self.nextPresenterButton.isHidden = true
                self.nextPresenterImageView.isHidden = true
            }
            //getPresenterDetails()
        }
        if let model = newsModel{
            self.title = "News"
            self.nextPresenterButton.setTitle("NEXT NEWS", for: UIControlState.normal)
            self.populateNewsData(news: model)
            self.selectedIndex = self.newsResponseModel?.newsItems.index(of: model)
            if (self.selectedIndex! + 1) == self.newsResponseModel?.newsItems.count{
                self.nextPresenterButton.isHidden = true
                self.nextPresenterImageView.isHidden = true
            }
        }
        if let model = eventsModel{
            self.title = "Events"
            self.nextPresenterButton.setTitle("NEXT EVENT", for: UIControlState.normal)
            self.populateEventsData(event: model)
            self.selectedIndex = self.eventsResponseModel?.eventsItems.index(of: model)
            if (self.selectedIndex! + 1) == self.eventsResponseModel?.eventsItems.count{
                self.nextPresenterButton.isHidden = true
                self.nextPresenterImageView.isHidden = true
            }
        }
        if let model = showsModel{
            self.title = "Shows"
            self.nextPresenterButton.setTitle("NEXT SHOW", for: UIControlState.normal)
            self.populateShowsData(show: model)
            self.selectedIndex = self.showsResponseModel?.showsItems.index(of: model)
            if (self.selectedIndex! + 1) == self.showsResponseModel?.showsItems.count{
                self.nextPresenterButton.isHidden = true
                self.nextPresenterImageView.isHidden = true
            }
        }
    }
    
    func initialisation(){
        addingLeftBarButton()
        addRightNavBarIcon()
        self.rightButton?.setImage(UIImage.init(named: "backArrow"), for: UIControlState.normal)
        settingBorderToBackListButton()
        self.newsDetailWebView.navigationDelegate = self
    }
    
    func settingBorderToBackListButton(){
        self.backListButton.layer.borderWidth = 0.5
        self.backListButton.layer.borderColor = Constant.Colors.commonGreenColor.cgColor
    }
    
    //MARK: Button Actions
    
    override func rightNavButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func fbButtonAction(_ sender: UIButton) {
        if let _model = presentersModel{
            loadWebUrl(webUrlString: (Constant.fbSharingLink))
        }
        if let model = newsModel{
            //loadWebUrl(webUrlString: (model.fbLink))
            self.shareTextOnFacebook(content: model.title)
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
        if let model = showsModel{
            loadWebUrl(webUrlString: (Constant.fbSharingLink))
        }
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        if let _model = presentersModel{
            loadWebUrl(webUrlString: (Constant.twitterSharingLink))
        }
        if let model = newsModel{
            self.shareTextOnTwitter(content: model.title)
            //loadWebUrl(webUrlString: (model.twitterLink))
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.twitterLink))
        }
        if let model = showsModel{
            loadWebUrl(webUrlString: (Constant.twitterSharingLink))
        }
    }
    
    @IBAction func backToListButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextPresenterButtonAction(_ sender: UIButton) {
        if let selIndex = self.selectedIndex{
            self.selectedIndex = selIndex + 1
            if pageType == PageType.EventsPage{
                    if let eventModel = self.eventsResponseModel?.eventsItems[self.selectedIndex!]{
                        self.eventsModel = eventModel
                        populateDetails()
                    }
                if (self.selectedIndex! + 1) == self.eventsResponseModel?.eventsItems.count{
                    self.selectedIndex = 0
                    if let eventModel = self.eventsResponseModel?.eventsItems[self.selectedIndex!]{
                        self.eventsModel = eventModel
                        populateDetails()
                    }
                    //self.nextPresenterButton.isHidden = true
                   // self.nextPresenterImageView.isHidden = true
                }
            }
            else if (pageType == PageType.NewsPage){
                if let newsModel = self.newsResponseModel?.newsItems[self.selectedIndex!]{
                    self.newsModel = newsModel
                    populateDetails()
                }
                if (self.selectedIndex! + 1) == self.newsResponseModel?.newsItems.count{
                    self.selectedIndex = 0
                    if let newsModel = self.newsResponseModel?.newsItems[self.selectedIndex!]{
                        self.newsModel = newsModel
                        populateDetails()
                    }
                    
//                    self.nextPresenterButton.isHidden = true
//                    self.nextPresenterImageView.isHidden = true
                }
            }
            else if (pageType == PageType.PresenterPage){
                if let presenterModel = self.presenterResponseModel?.presenterItems[self.selectedIndex!]{
                    self.presentersModel = presenterModel
                    populateDetails()
                }
                if (self.selectedIndex! + 1) == self.presenterResponseModel?.presenterItems.count{
                    self.selectedIndex = 0
                    if let presenterModel = self.presenterResponseModel?.presenterItems[self.selectedIndex!]{
                        self.presentersModel = presenterModel
                        populateDetails()
                    }
                    
//                    self.nextPresenterButton.isHidden = true
//                    self.nextPresenterImageView.isHidden = true
                }
            }
            else if (pageType == PageType.ShowsPage){
                if let showsModel = self.showsResponseModel?.showsItems[self.selectedIndex!]{
                    self.showsModel = showsModel
                    populateDetails()
                }
                if (self.selectedIndex! + 1) == self.showsResponseModel?.showsItems.count{
                    self.selectedIndex = 0
                    if let showsModel = self.showsResponseModel?.showsItems[self.selectedIndex!]{
                        self.showsModel = showsModel
                        populateDetails()
                    }
                    //self.nextPresenterButton.isHidden = true
                    //self.nextPresenterImageView.isHidden = true
                }
            }
            
        }
        
    }
    
    func populatePresenterData(presenter:PresenterModel){
        self.presenterNameLabel.text = presenter.title
        self.newsDetailWebView.loadHTMLString( appendingString + presenter.webViewContent, baseURL: nil)
         guard let encodedUrlstring =  presenter.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: (encodedUrlstring)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateNewsData(news:NewsModel){
        self.presenterNameLabel.text = news.title
        
        
        self.newsDetailWebView.loadHTMLString( appendingString + appendingString+news.webViewContent, baseURL: nil)
         guard let encodedUrlstring =  news.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: (encodedUrlstring)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateEventsData(event:EventsModel){
        self.presenterNameLabel.text = event.title
        self.newsDetailWebView.loadHTMLString( appendingString+event.webViewContent, baseURL: nil)
        guard let encodedUrlstring =  event.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: (encodedUrlstring)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateShowsData(show:ShowsModel){
        self.presenterNameLabel.text = show.title
         self.newsDetailWebView.loadHTMLString( appendingString+show.webViewContent, baseURL: nil)
        guard let encodedUrlstring =  show.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return }
        presenterImageView.sd_setImage(with: URL(string: (encodedUrlstring)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
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

extension PresenterDetailVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
