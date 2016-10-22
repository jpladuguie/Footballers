//
//  rankingsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class rankingsView: UIViewController {

    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "rankingsMenuSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Rankings"
        self.title = "Rankings"
        
        // Set background.
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Menu bar button
        let menuButton = UIButton(type: UIButtonType.custom) as UIButton
        menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        menuButton.setImage(UIImage(named: "menuButton.png"), for: UIControlState())
        menuButton.addTarget(self, action: #selector(rankingsView.menuOpened(_:)), for:.touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Navigation bar.
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
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
