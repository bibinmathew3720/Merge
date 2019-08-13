//
//  MenuVC.swift
//  Merge
//
//  Created by Bibin Mathew on 7/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
struct MenuItems {
    static var firstItem = "LOG IN"
    static var secondItem = "REGISTER"
    static var thirdItem = "PRESENTERS"
    static var fourthItem = "NEWS"
    static var fifthItem = "SHOWS"
    static var sixthItem = "CONTACT US"
    
}

class MenuVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuTVHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutIcon: UIImageView!
    @IBOutlet weak var logoutButtton: UIButton!
    
    var menuList: [String] = []
    var isLoggedIn:Bool!
    override func initView() {
        super.initView()
        initialisation()
        NotificationCenter.default.addObserver(self, selector: #selector(populateMenuItems), name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
    }
    
    func initialisation(){
        menuList = [MenuItems.firstItem,MenuItems.secondItem,MenuItems.thirdItem,MenuItems.fourthItem,MenuItems.fifthItem,MenuItems.sixthItem]
        populateMenuItems()
    }
    
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let loggedIn = isLoggedIn{
            if(loggedIn){
                return menuList.count
            }
            else{
                return menuList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoggedIn{
            if indexPath.row == 0{
                let profileCell : MenuProfileCell! = tableView.dequeueReusableCell(withIdentifier: "menuProfileCell") as! MenuProfileCell
                profileCell.setUserDetails()
                return profileCell
            }
        }
        let menuCell : MenuTVC! = tableView.dequeueReusableCell(withIdentifier: "menuTVC") as! MenuTVC
        menuCell.menuLabel.text = menuList[indexPath.row]
        menuCell.menuImageView.image = UIImage.init(named: menuList[indexPath.row])
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            if isLoggedIn{
                loadPageAtIndex(index: indexPath.row)
            }
            else{
                navigateToLogInPage()
            }
        }
        else if (indexPath.row == 1){
            navigateToRegisterPage()
        }
        else{
            loadPageAtIndex(index: indexPath.row)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        AlwisalUtility.showAlertWithOkOrCancel(_title: Constant.AppName, viewController: self, messageString: Constant.Messages.logoutMessage) { (success) in
            if success{
                self.processAfterLogout()
                self.navigateToLogInPage()
            }
        }
    }
    
    func loadPageAtIndex(index:Int){
        let tabBarCntlr = self.slideMenuController()?.mainViewController as! UITabBarController
        let selectedIndex = tabBarCntlr.selectedIndex
        let navCntlr = tabBarCntlr.viewControllers![selectedIndex] as! UINavigationController
        self.slideMenuController()?.closeLeft()
        let viewControllerAtIndex = getViewControllerAtMenuIndex(selIndex: index)
        navCntlr.pushViewController(viewControllerAtIndex, animated: true)
    }
    
    func getViewControllerAtMenuIndex(selIndex:NSInteger)->UIViewController{
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if (selIndex == 0){
            let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            return profileVC
        }
        if(selIndex == 2){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresentersVC") as! PresentersVC
             presenterVC.pageType = PageType.PresenterPage
            return presenterVC
        }
        else if(selIndex == 3){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresentersVC") as! PresentersVC
            presenterVC.pageType = PageType.NewsPage
            return presenterVC
        }
        else if(selIndex == 4){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresentersVC") as! PresentersVC
            presenterVC.pageType = PageType.ShowsPage
            return presenterVC
        }
        else if(selIndex == 5){
            let contactUsVC = storyBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            return contactUsVC
        }
        else{
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresentersVC")
            return presenterVC
        }
        
    }
    
    func navigateToRegisterPage(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        registerVC.isFromTabBar = true
        let registerNavController = UINavigationController.init(rootViewController: registerVC)
        self.slideMenuController()?.closeRight()
        DispatchQueue.main.async { () -> Void in
            self.present(registerNavController, animated: true)
        }
    }
    
    @objc func populateMenuItems(){
        isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(isLoggedIn){
            menuTVHeight.constant = CGFloat(50 * menuList.count)
            self.logoutIcon.isHidden = false
            self.logoutLabel.isHidden = false
            self.logoutButtton.isHidden = false
        }
        else{
            menuTVHeight.constant = CGFloat(50*menuList.count)
            self.logoutIcon.isHidden = true
            self.logoutLabel.isHidden = true
            self.logoutButtton.isHidden = true
        }
        menuTableView.reloadData()
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
