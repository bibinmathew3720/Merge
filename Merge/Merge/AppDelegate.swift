//
//  AppDelegate.swift
//  Merge
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        initWindow()
        setNavigationBarProperties()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(noticationObserverAction), name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
        return true
    }
    
    @objc func noticationObserverAction(){
        initWindow()
    }
    
    func initWindow(){
        window?.rootViewController = initialisingTabBar()
    }
    
    func setNavigationBarProperties(){
        UINavigationBar.appearance().barTintColor = Constant.Colors.commonGreenColor
      
        UINavigationBar.appearance().tintColor = Constant.Colors.commonGreenColor
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Poppins-Regular", size: 20)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    func initialisingTabBar()->ExSlideMenuController{
        let tabBarController = UITabBarController.init()
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
        chatVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "firstTabSelected", unselectedImage: "firstTabSelected", title: "CHAT") //Chat
        let firstNavVC = UINavigationController.init(rootViewController: chatVC)
        
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        secondVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "secondTabSelected", unselectedImage: "secondTabSelected", title: "INFO")//Play List
        let secondNavVC = UINavigationController.init(rootViewController: secondVC)
        
        let landingPageVC = storyBoard.instantiateViewController(withIdentifier: "LandingPageVC")
        landingPageVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.playIcon, unselectedImage: Constant.ImageNames.tabImages.playIcon, title: "")
        landingPageVC.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        let landingNavVC = UINavigationController.init(rootViewController: landingPageVC)
        
        let fourthVC = storyBoard.instantiateViewController(withIdentifier: "logInVC")
        fourthVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.muteIcon, unselectedImage: Constant.ImageNames.tabImages.muteIcon, title: "MUTE") // The sound
        let fourthNavVC = UINavigationController.init(rootViewController: fourthVC)
        
        let fifthVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")
        fifthVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "fifthTabSelected", unselectedImage: "fifthTabSelected", title: "SHARE") //Share
        let fifthNavVC = UINavigationController.init(rootViewController: fifthVC)
        
        tabBarController.viewControllers = [firstNavVC,secondNavVC,landingNavVC,fourthNavVC,fifthNavVC];
        customisingTabBarController(tabBarCnlr: tabBarController)
        tabBarController.selectedIndex = 2;
        let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuVC")
        
        let contactVC = storyBoard.instantiateViewController(withIdentifier: "ContactVC")
        let slideMenuController = ExSlideMenuController(mainViewController: tabBarController, leftMenuViewController:menuVC , rightMenuViewController: contactVC)
        return slideMenuController
    }
    
    func settingTabBarItemFontsAndImages(selectedImageName:String,unselectedImage:String,title:String)->UITabBarItem{
        let tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: unselectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: selectedImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        return tabBarItem
    }
    
    func customisingTabBarController(tabBarCnlr:UITabBarController){
        UITabBar.appearance().backgroundImage = UIImage(named: "tabBarBG")
        let appearance = UITabBarItem.appearance()
        let attributes = [kCTFontAttributeName:UIFont(name: "Poppins-Regular", size: 20)]
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.normal)
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.selected)
        appearance.setTitleTextAttributes(attributes as [NSAttributedStringKey : Any], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -8)
        UITabBar.appearance().contentMode = .scaleAspectFit
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Merge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

