//
//  PresenterDetailVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class PresenterDetailVC: BaseViewController {
    @IBOutlet weak var presenterImageView: UIImageView!
    @IBOutlet weak var presenterNameLabel: UILabel!
    @IBOutlet weak var presenterDesigLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backListButton: UIButton!
    @IBOutlet weak var nextPresenterButton: UIButton!
    @IBOutlet weak var nextPresenterImageView: UIImageView!
    
    var presenterResponseModel:PresenterResponseModel?
    var newsResponseModel:NewsResponseModel?
    var eventsResponseModel:EventsResponseModel?
    
    var presentersModel:PresenterModel?
    var newsModel:NewsModel?
    var eventsModel:EventsModel?
    var pageType:PageType?
    var selectedIndex:Int?
    override func initView() {
        super.initView()
        initialisation()
        populateDetails()
    }
    
    func populateDetails(){
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
    }
    
    func initialisation(){
        addingLeftBarButton()
        addRightNavBarIcon()
        self.rightButton?.setImage(UIImage.init(named: "backArrow"), for: UIControlState.normal)
        settingBorderToBackListButton()
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
            loadWebUrl(webUrlString: (_model.fbLink))
        }
        if let model = newsModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        if let _model = presentersModel{
            loadWebUrl(webUrlString: (_model.twitterLink))
        }
        if let model = newsModel{
            loadWebUrl(webUrlString: (model.twitterLink))
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.twitterLink))
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
                    self.nextPresenterButton.isHidden = true
                    self.nextPresenterImageView.isHidden = true
                }
            }
            else if (pageType == PageType.NewsPage){
                if let newsModel = self.newsResponseModel?.newsItems[self.selectedIndex!]{
                    self.newsModel = newsModel
                    populateDetails()
                }
                if (self.selectedIndex! + 1) == self.newsResponseModel?.newsItems.count{
                    self.nextPresenterButton.isHidden = true
                    self.nextPresenterImageView.isHidden = true
                }
            }
            else if (pageType == PageType.PresenterPage){
                if let presenterModel = self.presenterResponseModel?.presenterItems[self.selectedIndex!]{
                    self.presentersModel = presenterModel
                    populateDetails()
                }
                if (self.selectedIndex! + 1) == self.presenterResponseModel?.presenterItems.count{
                    self.nextPresenterButton.isHidden = true
                    self.nextPresenterImageView.isHidden = true
                }
            }
        }
        
    }
    
    func populatePresenterData(presenter:PresenterModel){
        self.presenterNameLabel.text = presenter.title
        self.presenterDesigLabel.text = presenter.content
        self.descriptionLabel.text = presenter.content
        presenterImageView.sd_setImage(with: URL(string: (presenter.imagePath)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateNewsData(news:NewsModel){
        self.presenterNameLabel.text = news.title
        self.presenterDesigLabel.text = news.content
        self.descriptionLabel.text = news.content
        presenterImageView.sd_setImage(with: URL(string: (news.imagePath)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateEventsData(event:EventsModel){
        self.presenterNameLabel.text = event.title
        self.presenterDesigLabel.text = event.content
        self.descriptionLabel.text = event.content
        presenterImageView.sd_setImage(with: URL(string: (event.imagePath)), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
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