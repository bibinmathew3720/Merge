//
//  WebViewVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 7/21/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: BaseViewController {
    @IBOutlet weak var webKitView: WKWebView!
    
    override func initView() {
        super.initView()
        initialisation()
        addingLeftBarButton()
        addRightNavBarIcon()
    }
    
    func initialisation(){
       self.title = "Contact Us"
       loadWebViewWithUrl(urlString:Constant.contactUsUrlString)
    }
    
    
    func loadWebViewWithUrl(urlString:String){
        let encodedUrlstring = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        if let _enocededString = encodedUrlstring{
            let myURL = URL(string:_enocededString)
            if let _url = myURL{
                let myRequest = URLRequest(url: _url)
                webKitView.load(myRequest)
            }
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
