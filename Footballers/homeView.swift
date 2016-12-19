//
//  homeView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/08/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// The main home View Controller.
class homeView: templateViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Data.
    var topScorersData = [[String: String]]()
    var topAssistsData = [[String: String]]()
    var topPasserData = [[String: String]]()
    
    // Section titles, such as "Top Scorers" and "Most Assists".
    var sectionTitles: [String]!
    
    
    /* viewDidLoad() */
    
    override func getData() -> Bool {
        self.topScorersData = getPlayerRankings(SortValue: "Goals", StartPosition: 0, EndPosition: 5)
        self.topAssistsData = getPlayerRankings(SortValue: "Assists", StartPosition: 0, EndPosition: 3)
        self.topPasserData = getPlayerRankings(SortValue: "PassSuccess", StartPosition: 0, EndPosition: 1)
        
        if self.topScorersData.isEmpty == false {
            return true
        }
        else {
            return false
        }
    }
    
    override func reloadData(sender:AnyObject) {
        
        self.refreshControl.endRefreshing()
        self.view.addSubview(self.activityIndicator)
        
        super.reloadData(sender: self)
        
    }
    
    
    // Called when the view loads.
    override func viewDidLoad() {
        
        self.type = .Home
        
        // Call viewDidLoad() in parent view controller.
        super.viewDidLoad()
        
        // Set the current page and title.
        currentView = .Home
        self.title = "Home"
        
        // Create loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Get the data in the background, and once it has finished create all the subviews.
        DispatchQueue.global(qos: .background).async {
            
            // Get the data needed for the tableViews.
            self.topScorersData = getPlayerRankings(SortValue: "Goals", StartPosition: 0, EndPosition: 5)
            self.topAssistsData = getPlayerRankings(SortValue: "Assists", StartPosition: 0, EndPosition: 3)
            self.topPasserData = getPlayerRankings(SortValue: "PassSuccess", StartPosition: 0, EndPosition: 1)
            DispatchQueue.main.async {
                
                // If the data has been received, create all the subViews with the data.
                if self.topScorersData.isEmpty == false {
                    self.createSubViews()
                }
                    // Otherwise, display the error message.
                else {
                    createErrorMessage(viewController: self, message: "Unable to connect to server.")
                    
                    // Fade out activity indicator and remove it from the view.
                    UIView.animate(withDuration: 1.0, animations: {
                        self.activityIndicator.alpha = 0.0
                        }, completion: { (complete: Bool) in
                            self.activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    /* createSubViews() */
    
    // Initiate all the subViews, and fade them in.
    func createSubViews() {
        
        // Create the main table view.
        self.tableView = UITableView(frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height - 116))
        // Register the seperate cell classes.
        self.tableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.tableView.register(playerRatingCell.self, forCellReuseIdentifier: NSStringFromClass(playerRatingCell.self))
        self.tableView.register(titleCell.self, forCellReuseIdentifier: NSStringFromClass(titleCell.self))
        self.tableView.register(playerDividerCell.self, forCellReuseIdentifier: NSStringFromClass(playerDividerCell.self))
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = lightGrey
        // Set the alpha to zero so it can be faded in.
        self.tableView.alpha = 0
        
        // Add the refresh control.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(reloadData(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        // Add views in correct order.
        self.view.addSubview(self.tableView)
        self.view.bringSubview(toFront: self.navBar)
        
        // Fade items in.
        /*UIView.animate(withDuration: 1.0, animations: {
            self.tableView.alpha = 1.0
            self.activityIndicator.alpha = 0.0
            }, completion: { (complete: Bool) in
                self.activityIndicator.removeFromSuperview()
        })*/
        
        self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.tableView)
        
    }
    
    /* Table view functions */
    
    // Set the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell?
            
        if (indexPath as NSIndexPath).row == 0 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
            title.titleLabel.text = "Top Scorers"
                
            // Set the main cell to the new one.
            cell = title
        }
            
        else if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
            
            // Create the custom cell using the rankingTableCell class..
            let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
            // Move the everything slightly to the left, as the ranking numbers will only
            // Be between 1 and 5, so space for only one digit is needed and not 3 which
            // Is the default.
            rankingCell.positionLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
            rankingCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
            rankingCell.nameLabel.frame = CGRect(x: 75, y: 0, width: 320, height: 40)
            
            // Assign the correct values to the tableView cell.
            rankingCell.positionLabel.text = String(indexPath.row)
            rankingCell.nameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Name"]
            rankingCell.statValueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Goals"]
            rankingCell.flagImage.image = UIImage(named: String((self.topScorersData[(indexPath as NSIndexPath).row - 1]["RegionCode"]?.uppercased())! + "")!)!
            
            // Set the cell.
            cell = rankingCell
        }
            
        else if (indexPath as NSIndexPath).row == 6 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
            title.titleLabel.text = "Most Assists"
                
            // Set the main cell to the new one.
            cell = title
        }
                
        else {
            // Create a cell from the playerRatingCell class.
            let ratingCell: playerRatingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerRatingCell.self), for: indexPath) as! playerRatingCell
                
            ratingCell.selectionStyle = .gray
                
            // Set the values of the rating name and its value.
            ratingCell.ratingNameLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Name"]
            ratingCell.ratingValueLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Assists"]
                
            // Get the rating value as a float.
            let ratingValue: Float = Float(self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Assists"]!)! / Float(self.topAssistsData[0]["Assists"]!)! * 100.0
            // Get the bar width depending on the value and the screen width.
            let barWidth: Int = Int(Float(ratingValue * Float(self.view.frame.width - 40)) / 100.0)
            // Create the bar as a UIView and set its colour depending on the strength of the rating.
            ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
            ratingCell.ratingBar.backgroundColor = getRatingColour(value: Int(ratingValue))
                
            // Animate the rating bar so that it slides in.
            UIView.animate(withDuration: 1.0, animations: {
                ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
            })
                
            // Set the main cell to the new one.
            cell = ratingCell
        }
        
        
        // Return the cell.
        cell?.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell!
    }
    
    // Set the row height for all tableViews to 40.0.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Titles
        if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 6{
            return 40.0
        }
        // Top Scorers
        else if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
            return 40.0
        }
        // Most Assists
        else {
            return 50.0
        }
    }
    
    // Called when a tableViewCell is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row != 0 && (indexPath as NSIndexPath).row != 6 {
        
            // Select the correct PlayerId depending on which tableView the selected cell is in.
            let playerData: [String: String]
        
            if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
                tableView.deselectRow(at: indexPath, animated: true)
                playerData = self.topScorersData[(indexPath as NSIndexPath).row - 1]
            }
            else {
                tableView.deselectRow(at: indexPath, animated: true)
                playerData = self.topAssistsData[(indexPath as NSIndexPath).row - 7]
            }
        
            // Assign value to selectedPlayerData.
            self.selectedPlayerData = playerData
        
            // Perform the segue to the player view.
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
            
        }
        else {
            
            if (indexPath as NSIndexPath).row == 0 {
                self.selectedRanking = "Goals"
            }
            else {
                self.selectedRanking = "Assists"
            }
            
            performSegue(withIdentifier: "homeRankingSegue", sender: self)
        }
    }
    
    // Called when a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If a player has been selected, send the correct PlayerId to the playerView.
        if(segue.identifier == "homePlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
        }
        // If a ranking has been selected, send the correct type of ranking to rankingsView.
        else if (segue.identifier == "homeRankingSegue") {
            //self.tabBarController?.selectedIndex = 1
            let rankingClass = (segue.destination as! rankingsView)
            rankingClass.rankingType = self.selectedRanking
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
