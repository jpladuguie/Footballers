//
//  favouritesView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class favouritesView: UIViewController {
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "favouritesMenuSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Favourites"
        self.title = "Favourites"
        
        setUpView(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
