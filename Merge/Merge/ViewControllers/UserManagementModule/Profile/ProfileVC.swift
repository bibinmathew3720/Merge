//
//  ProfileVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/18/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {

    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        self.title = "Profile"
        addingLeftBarButton()
        addRightNavBarIcon()
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
