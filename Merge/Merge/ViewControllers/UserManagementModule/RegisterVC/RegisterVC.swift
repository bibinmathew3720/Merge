//
//  RegisterVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class RegisterVC: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPwdView: UIView!
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var backToLogInButton: UIButton!
    
    var alwisalRegister = AlwisalRegister()
    
    var isFromTabBar:Bool?
    override func initView() {
        super.initView()
        initialisation()
        self.navigationController?.navigationBar.isHidden = true
        if let isTab = isFromTabBar{
            backToLogInButton.isHidden = true
        }
    }
    
    func initialisation(){
        settingBorderToView(view: nameView)
        settingBorderToView(view: emailView)
        settingBorderToView(view: passwordView)
        settingBorderToView(view: confirmPwdView)
        settingBorderToBackLoginButton()
    }
    
    func settingBorderToView(view:UIView){
        view.layer.borderColor = Constant.Colors.commonGrayColor.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func settingBorderToBackLoginButton(){
        self.backToLogInButton.layer.borderWidth = 0.5
        self.backToLogInButton.layer.borderColor = Constant.Colors.commonGreenColor.cgColor
    }
    
    //MARK: Button Actions

    @IBAction func registerButtonAction(_ sender: UIButton) {
        if (isValidInputs()){
            callingSignUpApi()
        }
    }
    
    @IBAction func backToLogInAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func skipAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameTF{
            emailTF.becomeFirstResponder()
        }
        else if textField == self.emailTF{
            passwordTF.becomeFirstResponder()
        }
        else if textField == self.passwordTF{
           confirmPwdTF.becomeFirstResponder()
        }
        return true
    }
    
    func isValidInputs()->Bool{
        var valid = true
        var validationMessage = ""
        if (nameTF.text?.isEmpty)!{
            validationMessage = "Please enter your name"
            valid = false
        }
        else if (emailTF.text?.isEmpty)!{
            validationMessage = "Please enter your email id"
            valid = false
        }
        else if !(emailTF.text?.isValidEmail())!{
            validationMessage = "Please enter valid email id"
            valid = false
        }
        else if (passwordTF.text?.isEmpty)!{
            validationMessage = "Please enter password"
            valid = false
        }
        else if (confirmPwdTF.text?.isEmpty)!{
            validationMessage = "Please enter confirm password"
            valid = false
        }
        else if (passwordTF.text != confirmPwdTF.text){
            validationMessage = "Password mismatch"
            valid = false
        }
        if (!valid){
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: validationMessage, parentController: self)
        }
        return valid
    }
    
    //MARK: Sign Up Api
    
    func  callingSignUpApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingSignUpApi(with: getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalRegisterResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    AlwisalUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: model.statusMessage, parentController: self, completion: { (okSuccess) in
                        if let isTab = self.isFromTabBar{
                           self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
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
            
            print(ErrorType)
        }
    }
    
    fileprivate func getRequestBody() -> String {
        alwisalRegister.username = nameTF.text!
        alwisalRegister.emailid = emailTF.text!
        alwisalRegister.password = passwordTF.text!
        return alwisalRegister.getRequestBody()
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
