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
    override func initView() {
        super.initView()
        initialisation()
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
    }
    
    @IBAction func backToLogInAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
