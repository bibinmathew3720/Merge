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
    
    override func initView() {
        super.initView()
        initilisation()
    }
    
    func initilisation(){
        settingBorderToView(view: userNameView)
        settingBorderToView(view: passwordView)
        settingBordrToRegisterButton()
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
    }
   
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.userNameTF{
            passwordTF.becomeFirstResponder()
        }
        return true
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
