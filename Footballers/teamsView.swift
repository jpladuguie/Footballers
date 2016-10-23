//
//  teamsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class teamsView: UIViewController {
    
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "teamsMenuSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Teams"
        self.title = "Teams"
        
        setUpView(viewController: self)
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
