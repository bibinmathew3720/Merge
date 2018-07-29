//
//  FirstLoginVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/11/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class FirstLoginVC: BaseViewController
{
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        self.navigationController?.navigationBar.isHidden = true;
    }

    @IBAction func fbButtonAction(_ sender: UIButton) {
    }
    @IBAction func googlePlusButtonAction(_ sender: UIButton) {
    }
    @IBAction func skipAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
    }
}
