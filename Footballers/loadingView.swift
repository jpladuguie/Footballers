//
//  loadingView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 15/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SideMenu
import Alamofire

// loadingView is the initial View Controller. Essentially all it does is set up the side
// View menu, and create a UIWebView which is off-screen. This webview connects to Whoscored.com,
// Gets the cookies from the session, and saves it in the global cookies variable. Every HTTP 
// Request uses these cookies whilst the app is still running. Once the cookies have been obtained,
// The segue to homeView is initiated.
class loadingView: UIViewController, UIWebViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background grey.
        self.view.backgroundColor = lightGrey
        
        // Navigation bar.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navBar = UIView()
        navBar.frame = CGRect(x: -1, y: 0, width: self.view.frame.width + 1, height: 64)
        navBar.backgroundColor = darkGrey
        self.view.addSubview(navBar)
        
        // Shadow effect.
        navBar.layer.shadowRadius = 1
        navBar.layer.shadowOpacity = 1
        navBar.layer.shadowColor = UIColor.black.cgColor
        navBar.layer.shadowOffset = CGSize.zero
        navBar.layer.shouldRasterize = true
        navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
        
        // Set up side menu.
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuShadowOpacity = 0.0
        SideMenuManager.menuPresentMode = .viewSlideInOut
        
        // Create loading activity indicator.
        let activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(activityIndicator)
        
}
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
