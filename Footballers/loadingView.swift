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

var cookies: [NSHTTPCookie] = [NSHTTPCookie]()
var currentPage: String = String()

class loadingView: UIViewController, UIWebViewDelegate {
    
    // Function is called once the webView finishes loading. It stores the cookies from the request, and calls the segue to the home screen.
    func webViewDidFinishLoad(webView: UIWebView) {
        if (webView.loading == false) {
            if let request = webView.request {
                if let resp = NSURLCache.sharedURLCache().cachedResponseForRequest(request) {
                    if let response = resp.response as? NSHTTPURLResponse {
                        if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                            
                            cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response.URL!)
                            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response.URL!, mainDocumentURL: nil)
                            
                            performSegueWithIdentifier("loadingSegue", sender: nil)
                            
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background.
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Navigation bar.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navBar = UIView()
        navBar.frame = CGRectMake(-1, 0, self.view.frame.width + 1, 64)
        navBar.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.view.addSubview(navBar)
        
        // Shadow effect.
        navBar.layer.shadowRadius = 1
        navBar.layer.shadowOpacity = 1
        navBar.layer.shadowColor = UIColor.blackColor().CGColor
        navBar.layer.shadowOffset = CGSizeZero
        navBar.layer.shouldRasterize = true
        navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).CGPath
        
        // Set up side menu.
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewControllerWithIdentifier("SideMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuShadowOpacity = 0.0
        SideMenuManager.menuPresentMode = .ViewSlideInOut
        
        // Loading activity indicator.
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width/2 - 25), y: (self.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.BallClipRotatePulse, color: UIColor.whiteColor())
        activityIndicator.startAnimation()
        self.view.addSubview(activityIndicator)
        
        
        // Get webpage and cookies.
        let request = NSURLRequest(URL: NSURL(string: "https://www.whoscored.com/AboutUs")!) 
        let webView:UIWebView = UIWebView(frame: CGRectMake(0, 0, 0, 0))
        webView.loadRequest(request)
        self.view.addSubview(webView)
        webView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
