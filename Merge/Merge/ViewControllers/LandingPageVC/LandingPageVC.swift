//
//  LandingPageVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LandingPageVC: BaseViewController {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var songerNameLabel: UILabel!
    
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
    
    //MARK: Button Actions
    
    @IBAction func favoriteBUttonAction(_ sender: UIButton) {
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
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
