//
//  FirstLoginVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/11/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
        login(type: .Facebook)
    }
    @IBAction func googlePlusButtonAction(_ sender: UIButton) {
    }
    @IBAction func skipAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
    }
    
    //MARK:- Social login
    func login(type: LoginType) {
        weak var weakSelf = self
        switch type {
        case .Facebook:
            
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email",], from: weakSelf) { (response, error) in
                if error == nil {
                    let result : FBSDKLoginManagerLoginResult = response!
                    if (result.grantedPermissions != nil) {
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result.token.tokenString, version: nil, httpMethod: "GET")
                        
                        req?.start(completionHandler: { (connection, userData, error) in
                            if (error == nil)
                            {
                                if let data = userData as? NSDictionary
                                {
                                    let firstName  = data.object(forKey: "first_name") as? String
                                    
                                    if let email = data.object(forKey: "email") as? String
                                    {
                                        weakSelf?.callSocialLogin(body: ["user_email" : email,
                                                                         "displayName" :firstName!])
                                    }
                                    else
                                    {
                                        weakSelf?.callSocialLogin(body: ["user_email" : "noemail@testmail.com",
                                                                         "displayName" :firstName!])
                                    }
                                }
                            }
                        })
                    }
                    else {
                        //show alert for have not permission
                        
                    }
                }
                else {
                    //show alert for eror
                    
                }
            }
            break
        case .Twitter:
            TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                if (session != nil) {
                    /* print("signed in as \(session?.userName)");
                     print("AuthToken \(session?.authToken)");
                     print("AuthTokenSecret \(session?.authTokenSecret)");*/
                    weakSelf?.callSocialLogin(body: ["user_email" : "noemail@testmail.com",
                                                     "displayName" :(session?.userName)!])
                } else {
                    
                }
            })
            break
        default: break
            
        }
    }
    func callSocialLogin(body: [String: String]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingSocialLogInApi(with: AlwisalUtility.getJSONfrom(dictionary: body), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalLogInResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
                    UserDefaults.standard.set(model.userToken, forKey: Constant.VariableNames.userToken)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
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
    
    
}

