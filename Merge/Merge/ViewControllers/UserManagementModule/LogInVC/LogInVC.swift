//
//  LogInVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/11/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LogInVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    var isFromTabBar:Bool?
    
    var alwisalLogIn = AlwisalLogIN()
    
    override func initView() {
        super.initView()
        initilisation()
    }
    
    func initilisation(){
        settingBorderToView(view: userNameView)
        settingBorderToView(view: passwordView)
        settingBordrToRegisterButton()
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    func settingBorderToView(view:UIView){
        view.layer.borderColor = Constant.Colors.commonGrayColor.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func settingBordrToRegisterButton(){
        self.registerButton.layer.borderWidth = 0.5
        self.registerButton.layer.borderColor = Constant.Colors.commonGreenColor.cgColor
    }
    
    //MARK: Button Actions

    @IBAction func logInButtonAction(_ sender: UIButton) {
        if (validate()){
            callingLogInApi()
        }
    }
   
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.userNameTF{
            passwordTF.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: Login Api Call
    
    func  callingLogInApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLogInApi(with: getRequestBody(), success: {
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
   
    fileprivate func getRequestBody() -> String {
        alwisalLogIn.userName = userNameTF.text!
        alwisalLogIn.password = passwordTF.text!
        return alwisalLogIn.getRequestBody()
    }
    
    // MARK: Validation
    
    func validate()->Bool{
        var valid = true
        var messageString = ""
        if(userNameTF.text?.isEmpty)!{
            valid = false
            messageString = "Please enter user name"
        }
        else if(passwordTF.text?.isEmpty)!{
            valid = false
            messageString = "Please enter password"
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
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
