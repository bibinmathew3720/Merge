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

class ProfileVC: BaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
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
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesHeadingLabel: UILabel!
    @IBOutlet weak var likesTableView: UITableView!
    
    var userResponseModel:AlwisalUserProfileResponseModel?
    var alwisalUpdateProfile = AlwisalUpdateProfile()
    var alwisalUserLikes: LikesResponseModel?
    var alwisalUserFavorites: FavoritesResponseModel?
    
    override func initView() {
        super.initView()
        initialisation()
        customisation()
        enablingProfilePage()
        callingGetUserProfilesApi()
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
        self.likesHeadingLabel.text = "SONGS YOU LIKED"
        self.profileView.isHidden = true
        self.editButton.isHidden = true
        self.likesView.isHidden = false
        enablingLikesPage()
    }
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        self.likesHeadingLabel.text = "SONGS YOU FAVORITED"
        self.profileView.isHidden = true
        self.editButton.isHidden = true
        self.likesView.isHidden = false
        enablingFavoritesPage()
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        if(self.validate()){
            self.callingUpdateProfileApi()
        }
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
        self.updateButton.isEnabled = true
    }
    
    func disablingProfileFields(){
        self.updateButton.alpha = 0.5
        self.view.endEditing(true)
        self.phoneNoTF.isEnabled = false
        self.emailTF.isEnabled = false
        self.addressTV.isEditable = false
         self.updateButton.isEnabled = false
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
    
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let likesCell : LikesTVC! = tableView.dequeueReusableCell(withIdentifier: "profileLikesCell") as! LikesTVC
        return likesCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    //MARK: Get User Profiles
    
    func callingGetUserProfilesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingGetUserProfilesApi(with: "", success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalUserProfileResponseModel{
                self.userResponseModel = model
                self.populateUserDetails()
                
            }
        }) {(ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    func populateUserDetails(){
        alwisalUpdateProfile.first_name = (self.userResponseModel?.firstName)!
        alwisalUpdateProfile.last_name = (self.userResponseModel?.lastName)!
        alwisalUpdateProfile.email = (self.userResponseModel?.userEmail)!
        alwisalUpdateProfile.phone_number = (self.userResponseModel?.phoneNo)!
        alwisalUpdateProfile.age = (self.userResponseModel?.age)!
        alwisalUpdateProfile.gender = (self.userResponseModel?.gender)!
        alwisalUpdateProfile.location = (self.userResponseModel?.location)!
        alwisalUpdateProfile.nationality = (self.userResponseModel?.nationality)!
        
        //Populating Fields
        
        self.nameLabel.text = (self.userResponseModel?.firstName)!+" "+(self.userResponseModel?.lastName)!
        self.phoneNoTF.text = (self.userResponseModel?.phoneNo)!
        self.emailTF.text = (self.userResponseModel?.userEmail)!
        self.addressTV.text = (self.userResponseModel?.location)!
        if self.userResponseModel?.location.count == 0{
            self.textViewHeightConstraint.constant = 20
        }
    }
    
    //MARK: Update User Profiles
    
    func  callingUpdateProfileApi(){
        alwisalUpdateProfile.email = self.emailTF.text!;
        alwisalUpdateProfile.phone_number = self.phoneNoTF.text!
        alwisalUpdateProfile.location = self.addressTV.text!
        MBProgressHUD.showAdded(to: self.view, animated: true)
    UserModuleManager().callingUpdateProfileApi(with:getRequestBodyForUpdateProfile() , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalUpdateProfileResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.disablingProfileFields()
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
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
    
    fileprivate func getRequestBodyForUpdateProfile() -> String {
        return alwisalUpdateProfile.getRequestBody()
    }
    
    func validate()->Bool{
        var valid = true
        var validationMessage = ""
        if (emailTF.text?.isEmpty)!{
            validationMessage = "Please enter your email id"
            valid = false
        }
        else if !(emailTF.text?.isValidEmail())!{
            validationMessage = "Please enter valid email id"
            valid = false
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: validationMessage, parentController: self)
        }
        return valid
    }
    
    //MARK - Get User Likes
    
    func callingGetUserLikesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingUserLikesApi(with:"" , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? LikesResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserLikes = model
                    self.likesTableView.reloadData()
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
    
    //MARK - Get User Favorites
    
    func callingGetUserFavoritesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingUserFavoritesApi(with:"" , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? FavoritesResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserFavorites = model
                    self.likesTableView.reloadData()
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
    
    //MARK : Calling Favorite Api
    
    func  callingAddToFavoriteApi(index:NSInteger){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBody(favoriteModel:(alwisalUserFavorites?.favoriteItems[index])!), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserFavorites?.favoriteItems.remove(at: index)
                    self.likesTableView.reloadData()
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
    
    func getFavoriteRequestBody(favoriteModel:FavoritesModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(favoriteModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK : Calling Like Api
    
    func  callingLikeApi(index:NSInteger){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBody(likeModel:(alwisalUserLikes?.likeItems[index])!), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserLikes?.likeItems.remove(at: index)
                    self.likesTableView.reloadData()
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
    
    func getLikeRequestBody(likeModel:LikesModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(likeModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
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
