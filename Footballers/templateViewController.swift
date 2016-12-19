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
// It includes all the methods/variables which are shared between the views.
class templateViewController: UIViewController {
    
    // Type of view - home, rankings or favourites.
    var type: viewType!
    
    // Navigation bar, using the custom navigationBar class.
    var navBar: navigationBar!
    
    // Navigation bar buttons.
    var searchButton: UIButton!
    var closeButton: UIButton!
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Error message if unable to connect to server.
    var errorLabel: UILabel!
    
    // Table view.
    var tableView: UITableView = UITableView()
    
    // Refresh control for the table view, so that it can be refreshed.
    var refreshControl: UIRefreshControl!
    
    // The player id or ranking type needed for a segue when a player or ranking table is selected.
    var selectedPlayerData = [String: String]()
    var selectedRanking: String?
    
    // Ranking type and title needed for rankingsView.
    // "Goals" is the default value.
    var rankingType: String! = "Goals"
    var rankingTitle: String! = "Goals"
    
    // Boolean which becomes true once the views, such as the table view, are initialised for the first time.
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
        
        // Add it to view, and make sure it as always at the front.
        self.view.addSubview(self.navBar)
        self.navBar.layer.zPosition = CGFloat(MAXFLOAT)
        
        // Add the search button to the navigation bar.
        self.searchButton = UIButton(type: UIButtonType.custom) as UIButton
        self.searchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.searchButton.setImage(UIImage(named: "search.png"), for: UIControlState())
        self.searchButton.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        
        // Create a close button, but don't add it to the navigation bar yet.
        self.closeButton = UIButton(type: UIButtonType.custom) as UIButton
        self.closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.closeButton.setImage(UIImage(named: "close.png"), for: UIControlState())
        self.closeButton.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        
        // Set the navigation bar button to the search button.
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = self.searchButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Keep the table view in position.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.errorLabel = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - 150, y: (self.view.frame.height / 2) - 15, width: 300, height: 30))
        // Set the colour to white, add the text and add to view.
        self.errorLabel.font = UIFont.systemFont(ofSize: 22.0)
        self.errorLabel.text = "No network connection"
        self.errorLabel.textColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        self.errorLabel.textAlignment = .center
        self.errorLabel.alpha = 0.0
        self.view.addSubview(self.errorLabel)
    }
    
    /* viewDidDisappear()/viewDidAppear() */
    
    // Called when the view disappears from the main view.
    // Move the search bar back to its original position if a player has been selected from search.
    override func viewDidDisappear(_ animated: Bool) {
        // Only toggle the view when it is already extended, i.e. a player has been selected from search.
        if self.navBar.viewExtended == true {
            self.navBar.toggleView(type: .Search)
            
            // Reset the search button.
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = self.searchButton
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    // Called when the view appears.
    // Update the search bar in case the user has began a search in another view.
    override func viewDidAppear(_ animated: Bool) {
        self.navBar.updateSearchBar()
    }
    
    /* Search button function. */
    
    // Called when the search button is pressed.
    @IBAction func searchButtonTouched(_ sender: AnyObject) {
        // Open/close the search bar.
        self.navBar.toggleView(type: .Search)
        
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
    
    /* Data functions */
    
    // Gets the data.
    // Called from the getData() method declared below down. This code is generic to all views, so the seperate
    // getData() method allows for custom code to be added.
    func getData(success: Bool) {
            
        // At this point the request to get the data has already been made. The success variable depends on whether the data
        // Was successfully retrieved.
        DispatchQueue.main.async {
                
            // If the data has been received, create all the subViews with the data.
            if success == true {
                // If the view hasn't been initialised, i.e. this is the first time it has been called, create all subviews.
                if self.viewInitialised == false {
                    self.createSubViews()
                    self.viewInitialised = true
                }
                else {
                    // Otherwise, reload the table view, and fade it in.
                    self.tableView.reloadData()
                    self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.tableView)
                }
            }
            // Otherwise, display the error message.
            else {
                self.view.bringSubview(toFront: self.navBar)
                    
                // Fade out activity indicator and remove it from the view.
                UIView.animate(withDuration: 0.5, animations: {
                    self.activityIndicator.alpha = 0.0
                    }, completion: { (complete: Bool) in
                        self.activityIndicator.removeFromSuperview()
                        //createErrorMessage(viewController: self, message: "Unable to connect to server.")
                        UIView.animate(withDuration: 0.5, animations: {
                            self.errorLabel.alpha = 1.0
                        })
                })
            }
        }
    }
    
    // Reloads data in the table view.
    func reloadData(sender:AnyObject) {
        
        // Ends the refresh control.
        self.refreshControl.endRefreshing()
        
        // Adds the activity indicator to the view.
        self.view.addSubview(self.activityIndicator)
        
        // Fade out the table view, fade in the activity indicator and reload the data.
        UIView.animate(withDuration: 0.25, animations: {
            // Fade out the table view.
            self.tableView.alpha = 0.0
            }, completion: { (complete: Bool) in
                // Fade in the acitivity indicator.
                UIView.animate(withDuration: 0.25, animations: {
                    self.activityIndicator.alpha = 1.0
                    }, completion: { (complete: Bool) in
                // Get the data in the background, and once it has finished reload the table view and fade out the activity indicator.
                self.getData()
            })
        })
    }
    
    /* Function declarations.
       Both are specific to the view so needed overriding in the individual classes. */
    
    // Called if the data is successfully obtained from the server.
    // Creates the table view and any other views which need initialising.
    func createSubViews() {
        
    }
    
    // Gets the data needed for the view.
    func getData() {
        
    }
    
    /* Other Functions */
    
    // Transitions between two views by fading out the first view then fading in the second.
    func transitionBetweenViews(firstView: UIView, secondView: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            // Fade the first view out.
            firstView.alpha = 0.0
            }, completion: { (complete: Bool) in
                // Remove the first view from view.
                firstView.removeFromSuperview()
                UIView.animate(withDuration: 0.25, animations: {
                    // Fade the second view in.
                    secondView.alpha = 1.0
                })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
