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
    static var fifthItem = "CONTACT US"
    
}

class MenuVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var menuTVHeight: NSLayoutConstraint!
    var menuList: [String] = []
    var isLoggedIn:Bool!
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        menuList = [MenuItems.firstItem,MenuItems.secondItem,MenuItems.thirdItem,MenuItems.fourthItem,MenuItems.fifthItem]
        isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(isLoggedIn){
            menuTVHeight.constant = CGFloat(50 * (menuList.count+1))
        }
        else{
            menuTVHeight.constant = CGFloat(50*menuList.count)
        }
    }
    
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let loggedIn = isLoggedIn{
            if(loggedIn){
                return menuList.count+1
            }
            else{
                return menuList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell : MenuTVC! = tableView.dequeueReusableCell(withIdentifier: "menuTVC") as! MenuTVC
        menuCell.backgroundColor = UIColor.clear
        menuCell.menuLabel.text = menuList[indexPath.row]
        menuCell.menuImageView.image = UIImage.init(named: menuList[indexPath.row])
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            navigateToLogInPage()
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
        
        if(selIndex == 2){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresentersVC") as! PresentersVC
            return presenterVC
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
