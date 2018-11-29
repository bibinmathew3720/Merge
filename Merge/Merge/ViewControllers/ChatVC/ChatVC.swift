//
//  ChatVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ChatVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatComposerView: UIView!
    @IBOutlet weak var chatBottomConstraint: NSLayoutConstraint!
    
    var chatResponseModel:ChatResponseModel?
    var timer:Timer!
    var isAdminNotAvailablePopupAlreadyShows = false
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        self.title = "Chat"
        addingLeftBarButton()
        addRightNavBarIcon()
        self.rightButton?.setImage(UIImage.init(named: "backArrow"), for: UIControlState.normal)
        chatTableView.estimatedRowHeight = 50.0
        chatTableView.rowHeight = UITableViewAutomaticDimension
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getChatMessagesApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentTimer = timer {
            currentTimer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(self.timerAction)), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func timerAction(){
        self.getChatMessagesApi()
    }
    
    override func rightNavButtonAction() {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        sendChatMessage(message: self.chatTextView.text)
    }
    
    @IBAction func attachButtonAction(_ sender: UIButton) {
        addingActionSheetForPhotos()
    }
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _model = chatResponseModel else {
            return 0
        }
        return _model.chatItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _model = chatResponseModel{
            let chatModel = _model.chatItems[indexPath.row]
            let fromUser:Int = UserDefaults.standard.value(forKey: Constant.VariableNames.userId) as! Int
            let fromUserString = String(fromUser)
            if(chatModel.fromUser == fromUserString){
                if(!chatModel.message.isEmpty){//Loading Right Message Cell(Logged In User)
                    let chatRightCell : ChatRightCell! = tableView.dequeueReusableCell(withIdentifier: "chatRightCell") as! ChatRightCell
                    chatRightCell.backgroundColor = UIColor.clear
                    chatRightCell.setChatMessageDetails(chatMessageDetails:chatModel)
                    return chatRightCell
                }
                else{//Loading Right Image Cell
                    let chatRightImageCell : ChatRightImageViewCell! = tableView.dequeueReusableCell(withIdentifier: "chatRightImageCell") as! ChatRightImageViewCell
                    chatRightImageCell.backgroundColor = UIColor.clear
                    chatRightImageCell.setChatMessageDetails(chatMessageDetails:chatModel)
                    
                    chatRightImageCell.chatRightImageView.sd_setImage(with: URL(string: (self.chatResponseModel?.uploadDir)!+chatModel.filePath), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
                    return chatRightImageCell
                }
            }
            else{
                if(!chatModel.message.isEmpty){//Loading Left Message Cell
                    let chatLeftCell : ChatleftCell! = tableView.dequeueReusableCell(withIdentifier: "chatLeftCell") as! ChatleftCell
                    chatLeftCell.setChatMessageDetails(chatMessageDetails:chatModel)
                    chatLeftCell.backgroundColor = UIColor.clear
                    return chatLeftCell
                }
                else{//Loading Left Image Cell
                    let chatLeftImageCell : ChatLeftImageViewCell! = tableView.dequeueReusableCell(withIdentifier: "chatLeftImageCell") as! ChatLeftImageViewCell
                    chatLeftImageCell.backgroundColor = UIColor.clear
                    chatLeftImageCell.setChatMessageDetails(chatMessageDetails:chatModel)
                    chatLeftImageCell.chatLeftImageView.sd_setImage(with: URL(string: (self.chatResponseModel?.uploadDir)!+chatModel.filePath), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
                    return chatLeftImageCell
                }
            }
        }
        
        let chatRightImageCell : ChatRightImageViewCell! = tableView.dequeueReusableCell(withIdentifier: "chatRightImageCell") as! ChatRightImageViewCell
        chatRightImageCell.backgroundColor = UIColor.clear
        return chatRightImageCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: Get Chat Messages
    
    func  getChatMessagesApi(){
        UserModuleManager().callingChatMessagesApi(with: "", success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ChatResponseModel{
                if model.errorCode == 1{
                    
                    if(!self.isAdminNotAvailablePopupAlreadyShows){
                        AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                        self.isAdminNotAvailablePopupAlreadyShows = true
                    }
                }
                else{
                    self.chatResponseModel = model
                    self.populateChatData()
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
    
    func sendChatMessage(message:String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingSendChatMessageApi(with: getChatMessageRequestBody(message: message), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ChatModel{
                //                if model.errorCode == 1{
                //                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                //                }
                //                else{
                self.chatTextView.text = ""
                self.chatResponseModel?.chatItems.append(model)
                self.populateChatData()
                // }
                
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
    
    func getChatMessageRequestBody(message:String)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(message, forKey: "message")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    
    func populateChatData(){
        self.chatTableView.reloadData()
        if let _model = chatResponseModel{
            if _model.chatItems.count > 0
            {
                let indexPath = IndexPath.init(row: (_model.chatItems.count-1), section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .none, animated: false)
            }
        }
    }
    
    func addingActionSheetForPhotos(){
        let photoActionSheet = UIAlertController.init(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "Camera", style: .destructive) { (alert:UIAlertAction) in
            self.addingImagePickerController(sourceType: .camera)
        }
        let galleryAction = UIAlertAction.init(title: "Choose from Gallery", style: .default) { (alert:UIAlertAction) in
            self.addingImagePickerController(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert:UIAlertAction) in
            
        }
        photoActionSheet.addAction(cameraAction)
        photoActionSheet.addAction(galleryAction)
        photoActionSheet.addAction(cancelAction)
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    func addingImagePickerController(sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType;
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let referenceURL = info["UIImagePickerControllerReferenceURL"] as? URL
            if let refUrl = referenceURL {
                sendChatImage(image: pickedImage, ext: (refUrl.pathExtension))
            }
            else {
                sendChatImage(image: pickedImage, ext: "JPG")
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Sending Chat Image
    
    func sendChatImage(image:UIImage, ext: String){
        
        guard let userToken = UserDefaults.standard.value(forKey: Constant.VariableNames.userToken) else {
            return
        }
        let headers = ["Usertoken" : userToken,
                       "Authentication" : Constant.AuthenticationToken]
        let imageData = UIImageJPEGRepresentation(image, 0.25)
        CLNetworkManager.upload(file: imageData!,
                                type: .JPEG, ext: ext,
                                url: "http://test.radiomerge.fm/wp-json/wp/v2/send_user_message",
                                parameters: "file_doc",
                                headers: (headers as! [String : String]))
        {
            (response, status, error) in
            
        }
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
