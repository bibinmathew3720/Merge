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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
