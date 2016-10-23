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

var cookies: [HTTPCookie] = [HTTPCookie]()
var currentPage: String = String()

class loadingView: UIViewController, UIWebViewDelegate {
    
    // Function is called once the webView finishes loading. It stores the cookies from the request, and calls the segue to the home screen.
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView.isLoading == false) {
            if let request = webView.request {
                if let resp = URLCache.shared.cachedResponse(for: request) {
                    if let response = resp.response as? HTTPURLResponse {
                        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                            
                            cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
                            HTTPCookieStorage.shared.setCookies(cookies, for: response.url!, mainDocumentURL: nil)
                            
                            //reloadPlayerData()
                            
                            performSegue(withIdentifier: "loadingSegue", sender: nil)
                            
                        }
                    }
                }
            }
        }
    }

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
        
        // Loading activity indicator.
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width/2 - 25), y: (self.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        // Get webpage and cookies.
        let request = NSURLRequest(url: URL(string: "https://www.whoscored.com/AboutUs")!)
        let webView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        webView.loadRequest(request as URLRequest)
        self.view.addSubview(webView)
        webView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
