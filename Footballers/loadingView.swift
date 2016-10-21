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
import CoreData
import SwiftyJSON

var cookies: [HTTPCookie] = [HTTPCookie]()
var currentPage: String = String()

class loadingView: UIViewController, UIWebViewDelegate {
    
    var container: NSPersistentContainer!
    
    // Function is called once the webView finishes loading. It stores the cookies from the request, and calls the segue to the home screen.
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView.isLoading == false) {
            if let request = webView.request {
                if let resp = URLCache.shared.cachedResponse(for: request) {
                    if let response = resp.response as? HTTPURLResponse {
                        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                            
                            cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
                            HTTPCookieStorage.shared.setCookies(cookies, for: response.url!, mainDocumentURL: nil)
                            
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
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Navigation bar.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navBar = UIView()
        navBar.frame = CGRect(x: -1, y: 0, width: self.view.frame.width + 1, height: 64)
        navBar.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
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
        
        /*var json: JSON!
        
        let path = Bundle.main.path(forResource: "playerData", ofType: "txt")
        let text = try? NSString(contentsOfFile: path! as String, encoding: String.Encoding.utf8.rawValue)
        if let dataFromString = text!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        // INIT
        self.container = NSPersistentContainer(name: "playerDataModel")
        
        self.container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        /*
        for (key, subJson):(String, JSON) in json["players"] {
            let player = PlayerData(context: self.container.viewContext)
            player.playerId = String(describing: subJson["playerId"])
            player.name = String(describing: subJson["name"])
            player.regionCode = String(describing: subJson["regionCode"])
        }
        
        self.saveContext()*/
        
        
        var commitPredicate: NSPredicate?
        commitPredicate = NSPredicate(format: "name CONTAINS[c] 'aaron'")
        
        // FETCH
        var objects = [PlayerData]()
        let request = PlayerData.createFetchRequest()
        //let sort = NSSortDescriptor(key: "name", ascending: false)
        //request.sortDescriptors = [sort]
        request.predicate = commitPredicate
        
        do {
            objects = try container.viewContext.fetch(request)
            print("Got \(objects.count) commits")
        } catch {
            print("Fetch failed")
        }
        
        for object in objects {
            print(object.name)
        }
        */
        
        
        /*var i = 0
        while i < 5 {
            let player = PlayerFavouritesData(context: self.container.viewContext)
            player.playerId = String(describing: json["players"][i]["playerId"])
            player.name = String(describing: json["players"][i]["name"])
            player.regionCode = String(describing: json["players"][i]["regionCode"])
            
            i += 1
        }
        
        self.saveContext()*/
        

        
    }
    
    func saveContext() {
        if self.container.viewContext.hasChanges {
            do {
                try self.container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
