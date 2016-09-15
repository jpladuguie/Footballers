//
//  teamsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class teamsView: UIViewController {
    
    @IBAction func menuOpened(sender: AnyObject) {
        performSegueWithIdentifier("teamsMenuSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Teams"
        self.title = "Teams"
        
        // Set background.
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)

        // Menu bar button
        let menuButton = UIButton(type: UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(0, 0, 25, 25)
        menuButton.setImage(UIImage(named: "menuButton.png"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(teamsView.menuOpened(_:)), forControlEvents:.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Navigation bar.
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
