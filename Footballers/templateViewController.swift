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
    var searchButton: UIBarButtonItem!
    var closeButton: UIBarButtonItem!
    // Options button is only for rankings view.
    var optionsButton: UIBarButtonItem!
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Error message if unable to connect to server.
    var errorLabel: UIButton!
    
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
        let searchButtonView = UIButton(type: UIButtonType.custom) as UIButton
        searchButtonView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        searchButtonView.setImage(UIImage(named: "search.png"), for: UIControlState())
        searchButtonView.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        self.searchButton = UIBarButtonItem()
        self.searchButton.customView = searchButtonView
        
        // Create a close button, but don't add it to the navigation bar yet.
        let closeButtonView = UIButton(type: UIButtonType.custom) as UIButton
        closeButtonView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        closeButtonView.setImage(UIImage(named: "close.png"), for: UIControlState())
        closeButtonView.addTarget(self, action: #selector(searchButtonTouched(_:)), for:.touchUpInside)
        self.closeButton = UIBarButtonItem()
        self.closeButton.customView = closeButtonView
        
        // Create an options button for rankings view.
        let optionsButtonView = UIButton(type: UIButtonType.custom) as UIButton
        optionsButtonView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        optionsButtonView.setImage(UIImage(named: "config.png"), for: UIControlState())
        optionsButtonView.addTarget(self, action: #selector(rankingsView.optionButtonTouched(_:)), for:.touchUpInside)
        self.optionsButton = UIBarButtonItem()
        self.optionsButton.customView = optionsButtonView
        
        // Set the navigation bar button to the search button.
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        // Keep the table view in position.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Create an error label in case it is needed, i.e. if the app is unable to connect to the server.
        let errorText = NSMutableAttributedString(string: "No network connection", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightLight)])
        let errorTextBottomLine = NSMutableAttributedString(string: "\nTap to refresh", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)])
        errorText.append(errorTextBottomLine)
        
        // Create the error label.
        self.errorLabel = UIButton(type: .system) as UIButton
        self.errorLabel.frame = CGRect(x: (self.view.frame.width / 2) - 150, y: (self.view.frame.height / 2) - 30, width: 300, height: 60)
        // Set it to reload the data when pressed.
        self.errorLabel.addTarget(self, action: #selector(reloadData(sender:)), for: .touchUpInside)
        self.errorLabel.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.errorLabel.titleLabel?.textAlignment = .center
        self.errorLabel.tintColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        // Set the button's label.
        self.errorLabel.setAttributedTitle(errorText, for: .normal)
        // Initialise it with alpha = 0.0 as it should appear off screen at first.
        self.errorLabel.alpha = 0.0
        // Add it to view.
        self.view.addSubview(self.errorLabel)
        
    }
    
    /* viewDidDisappear()/viewDidAppear() */
    
    // Called when the view disappears from the main view.
    // Move the search bar back to its original position if a player has been selected from search.
    override func viewDidDisappear(_ animated: Bool) {
        // Only toggle the view when it is already extended, i.e. a player has been selected from search.
        if self.navBar.viewExtended == true {
            self.navBar.toggleView(type: .Search)
            
            // Reset the search button, i.e remove the close button.
            self.navigationItem.rightBarButtonItem = self.searchButton
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
        if self.navBar.viewExtended == true {
            self.navigationItem.setRightBarButton(self.closeButton, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
        else {
            self.navigationItem.setRightBarButton(self.searchButton, animated: true)
        }
    }
    
    /* Data functions */
    
    // Gets the data.
    // Called from the getData() method declared below down. This code is generic to all views, so the seperate
    // getData() method defined further down allows for custom code to be added.
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
        
        // End the refresh control if the function is being called after the view has been initialised.
        if self.viewInitialised == true {
            self.refreshControl.endRefreshing()
        }
        
        // Adds the activity indicator to the view.
        self.view.addSubview(self.activityIndicator)
        
        // Fade out the table view, fade in the activity indicator and reload the data.
        UIView.animate(withDuration: 0.25, animations: {
            // Fade out the table view.
            self.tableView.alpha = 0.0
            // Remove the error label if it is already showing.
            self.errorLabel.alpha = 0.0
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
        
        // Create the tableView with the data,
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 124))
        self.tableView.backgroundColor = lightGrey
        self.tableView.alpha = 0.0
        
        // Add the refresh control.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.white
        self.tableView.addSubview(self.refreshControl)
        
        // Add the views in the correct order.
        self.view.addSubview(self.tableView)
        self.view.bringSubview(toFront: self.navBar)
        
        // Fade table view in.
        self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.tableView)
    }
    
    // Gets the data needed for the view.
    func getData() {
        
    }
    
    /* Other Functions */
    
    // Reload data when the table view has been pulled down and released.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Only called when the table view is refreshing, i.e. it has been pulled below the threshold limit.
        if self.refreshControl.isRefreshing == true {
            self.reloadData(sender: self)
        }
    }
    
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
