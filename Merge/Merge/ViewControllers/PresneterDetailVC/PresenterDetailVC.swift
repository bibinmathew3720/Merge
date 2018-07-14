//
//  PresenterDetailVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/14/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class PresenterDetailVC: BaseViewController {

    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        self.title = "Presenters"
        addingLeftBarButton()
        addRightNavBarIcon()
        self.rightButton?.setImage(UIImage.init(named: "backArrow"), for: UIControlState.normal)
    }
    
    //MARK: Button Actions
    
    override func rightNavButtonAction() {
        self.navigationController?.popViewController(animated: true)
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
