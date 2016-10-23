//
//  compareView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class compareView: UIViewController {
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "compareMenuSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Compare"
        self.title = "Compare"
        
        setUpView(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
