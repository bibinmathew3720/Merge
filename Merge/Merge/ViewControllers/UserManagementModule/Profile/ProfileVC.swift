//
//  ProfileVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/18/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

let PROFILETITLE = "PROFILE"
let LIKESTITLE = "LIKES"
let FAVORITESTITLE = "FAVORITES"

class ProfileVC: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    
    @IBOutlet weak var profileButtonBG: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileButtonView: UIView!
    
    @IBOutlet weak var likesButtonBG: UIImageView!
    @IBOutlet weak var likeButtonView: UIView!
    @IBOutlet weak var likesButton: UIButton!
    
    @IBOutlet weak var favoriteButtonView: UIView!
    @IBOutlet weak var favoritesButtonBG: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var updateButtonImageView: UIImageView!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var likesView: UIView!
    
    override func initView() {
        super.initView()
        initialisation()
        customisation()
        enablingProfilePage()
    }
    
    func initialisation(){
        self.title = "Profile"
        addingLeftBarButton()
        addRightNavBarIcon()
    }
    
    func customisation(){
       customisingButton(button: profileButton)
       customisingButton(button: likesButton)
       customisingButton(button: favoritesButton)
        self.updateButton.alpha = 0.5
    }
    
    func customisingButton(button:UIButton){
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
    }
    
    //MARK: Button Actions
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        enablingProfileFields()
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton){
        self.profileView.isHidden = false
        self.editButton.isHidden = false
        self.likesView.isHidden = true
        enablingProfilePage()
    }
    
    @IBAction func likesButtonAction(_ sender: UIButton) {
        self.profileView.isHidden = true
        self.editButton.isHidden = true
        self.likesView.isHidden = false
        enablingLikesPage()
    }
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        self.profileView.isHidden = true
        self.editButton.isHidden = true
        self.likesView.isHidden = false
        enablingFavoritesPage()
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
    }
    
    func enablingProfilePage(){
        self.profileButtonBG.isHidden = false
        self.favoritesButtonBG.isHidden = true
        self.likesButtonBG.isHidden = true
        settingWhiteButtonWithTitle(title: PROFILETITLE, button: self.profileButton)
        settingBlueButtonWithTitle(title: LIKESTITLE, button: self.likesButton)
        settingBlueButtonWithTitle(title: FAVORITESTITLE, button: self.favoritesButton)
        
    }
    
    func enablingLikesPage(){
        self.likesButtonBG.isHidden = false
        self.profileButtonBG.isHidden = true
        self.favoritesButtonBG.isHidden = true
        settingBlueButtonWithTitle(title: PROFILETITLE, button: self.profileButton)
        settingWhiteButtonWithTitle(title: LIKESTITLE, button: self.likesButton)
        settingBlueButtonWithTitle(title: FAVORITESTITLE, button: self.favoritesButton)
        
    }
    
    func enablingFavoritesPage(){
        self.profileButtonBG.isHidden = true
        self.likesButtonBG.isHidden = true
        self.favoritesButtonBG.isHidden = false
        settingBlueButtonWithTitle(title: PROFILETITLE, button: self.profileButton)
        settingBlueButtonWithTitle(title: LIKESTITLE, button: self.likesButton)
        settingWhiteButtonWithTitle(title: FAVORITESTITLE, button: self.favoritesButton)
    }
    
    func settingBlueButtonWithTitle(title:String,button:UIButton){
        button.layer.borderColor = Constant.Colors.commonGreenColor.cgColor
        button.setTitleColor(Constant.Colors.commonGreenColor, for: UIControlState.normal)
    }
    
    func settingWhiteButtonWithTitle(title:String,button:UIButton){
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    //MARK: Enabling or Disabling Profile Fields
    
    func enablingProfileFields(){
        self.updateButton.alpha = 1.0
        self.phoneNoTF.isEnabled = true
        self.phoneNoTF.becomeFirstResponder()
        self.emailTF.isEnabled = true
        self.addressTV.isEditable = true
    }
    
    func disablingProfileFields(){
        self.updateButton.alpha = 0.5
        self.view.endEditing(true)
        self.phoneNoTF.isEnabled = false
        self.emailTF.isEnabled = false
        self.addressTV.isEditable = false
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.phoneNoTF{
            emailTF.becomeFirstResponder()
        }
        else if textField == self.emailTF{
            addressTV.becomeFirstResponder()
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
