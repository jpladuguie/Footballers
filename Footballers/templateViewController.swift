//
//  templateViewController.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 18/12/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// Template class for homeView, rankingsView and favouritesView.
class templateViewController: UIViewController {
    
    // Type of view - home, rankings or favourites.
    var type: viewType!
    
    // Navigation bar, using the custom navigationBar class.
    var navBar: navigationBar!
    
    // Navigation bar buttons.
    var searchButton: UIButton!
    var closeButton: UIButton!
    
    // Table view.
    var tableView: UITableView = UITableView()
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // The player id or ranking type needed for a segue when a player or ranking table is selected.
    var selectedPlayerData = [String: String]()
    var selectedRanking: String?
    
    // Ranking type needed for rankingsView.
    var rankingType: String! = "Goals"
    // Set default values for page title and ranking type.
    var rankingTitle: String! = "Goals"
    
    // Refresh control.
    var refreshControl: UIRefreshControl!
    
    
    
    var viewInitialised: Bool = false
    
    
    /* viewDidLoad() */
    
    // Called when the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set background colour.
        self.view.backgroundColor = lightGrey
        
        // Set the current navigation bar colour to transparent.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Create the custom navigation bar.
        self.navBar = navigationBar(frame: self.view.frame, type: self.type)
        self.navBar.viewController = self
        self.view.addSubview(self.navBar)
        
        // Add the search button to the navigation bar.
        self.searchButton = UIButton(type: UIButtonType.custom) as UIButton
        self.searchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.searchButton.setImage(UIImage(named: "search.png"), for: UIControlState())
        self.searchButton.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        
        // Create a 'close' button, but don't add it to the navigation bar yet.
        self.closeButton = UIButton(type: UIButtonType.custom) as UIButton
        self.closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.closeButton.setImage(UIImage(named: "close.png"), for: UIControlState())
        self.closeButton.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        
        // Add the search button to the navigation bar.
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = self.searchButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Keep the table view in position.
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /* viewDidAppear() */
    
    // Called when the view disappears from the main view.
    // Move the search bar back to its original position if a player has been selected from search.
    override func viewDidDisappear(_ animated: Bool) {
        // Only toggle the view when it is already extended, i.e. a player has been selected from search.
        if self.navBar.viewExtended == true {
            self.navBar.toggleSearch()
            
            // Reset the search button.
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = self.searchButton
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    // Called when the view appears.
    override func viewDidAppear(_ animated: Bool) {
        self.navBar.updateSearchBar()
    }

    // Called when the search button is pressed.
    @IBAction func searchButtonTouched(_ sender: UIButton) {
        // Open/close the search bar.
        self.navBar.toggleSearch()
        
        // Change the button to the search icon or the close icon depending on whether the search is already open.
        let rightBarButton = UIBarButtonItem()
        
        if self.navBar.viewExtended == true {
            rightBarButton.customView = self.closeButton
        }
        else {
            rightBarButton.customView = self.searchButton
        }
        
        // Set the button to the navigation bar.
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func getData() -> Bool {
        return false
    }
    
    func reloadData(sender:AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.alpha = 0.0
            }, completion: { (complete: Bool) in
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.activityIndicator.alpha = 1.0
                    }, completion: { (complete: Bool) in
                // Code to refresh table view
                // Get the data in the background, and once it has finished create all the subviews.
                DispatchQueue.global(qos: .background).async {
                    
                    // Get the data needed for the tableViews.
                    let success = self.getData()
                    
                    DispatchQueue.main.async {
                        
                        // If the data has been received, create all the subViews with the data.
                        if success == true {
                            self.tableView.reloadData()
                            self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.tableView)
                        }
                            // Otherwise, display the error message.
                        else {
                            createErrorMessage(viewController: self, message: "Unable to connect to server.")
                            
                            // Fade out activity indicator and remove it from the view.
                            UIView.animate(withDuration: 0.5, animations: {
                                self.activityIndicator.alpha = 0.0
                                }, completion: { (complete: Bool) in
                                    self.activityIndicator.removeFromSuperview()
                            })
                        }
                    }
                }
            })
        })
    }
    
    func transitionBetweenViews(firstView: UIView, secondView: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            firstView.alpha = 0.0
            }, completion: { (complete: Bool) in
                firstView.removeFromSuperview()
                UIView.animate(withDuration: 0.25, animations: {
                    secondView.alpha = 1.0
                })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
