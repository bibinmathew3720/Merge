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
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        menuList = [MenuItems.firstItem,MenuItems.secondItem,MenuItems.thirdItem,MenuItems.fourthItem,MenuItems.fifthItem]
        menuTVHeight.constant = CGFloat(50*menuList.count)
    }
    
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
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
