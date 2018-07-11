//
//  ForgotPasswordVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var backToLogInButton: UIButton!
    
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        settingBorderToView(view: emailView)
        settingBordrToBackLoginButton()
    }
    
    func settingBorderToView(view:UIView){
        view.layer.borderColor = Constant.Colors.commonGrayColor.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func settingBordrToBackLoginButton(){
        self.backToLogInButton.layer.borderWidth = 0.5
        view.layer.borderColor = Constant.Colors.commonGreenColor.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func backToLogInButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
