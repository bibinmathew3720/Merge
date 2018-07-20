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
    
    var presentersModel:PresenterModel?
    var newsModel:NewsModel?
    var eventsModel:EventsModel?
    var pageType:PageType?
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        self.title = "Presenters"
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
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func backToListButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextPresenterButtonAction(_ sender: UIButton) {
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
