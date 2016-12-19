//
//  rankingsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class rankingsView: templateViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Navigation bar.
    var optionsButton: UIButton!
    
    // currentStartPosition holds the value used in the next call to the API. As the table is scrolled through, it is increased,
    // As players further down in the rankings need to be fetched.
    var currentStartPosition: Int = 0
    
    // bottomReached becomes true once the last players have been called, i.e. the table view has been scrolled all the way
    // To the bottom. This prevents excessive calls to the API.
    var bottomReached = false
    
    // Player data array and table view.
    var players = [[String: String]]()
    
    
    /* viewDidLoad() */
    
    // Called as soon as the view loads.
    override func viewDidLoad() {
        // Set the view type.
        self.type = .Rankings
        
        // Call
        super.viewDidLoad()
        
        // Set the current page and title.
        currentView = .Rankings
        self.title = "Goals"
        
        // Add the options button to the navigation bar.
        self.optionsButton = UIButton(type: UIButtonType.custom) as UIButton
        self.optionsButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.optionsButton.setImage(UIImage(named: "config.png"), for: UIControlState())
        self.optionsButton.addTarget(self, action: #selector(rankingsView.optionButtonTouched(_:)), for:.touchUpInside)
        
        // Set the navigation bar button to the options button.
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = self.optionsButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Create loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Get the data and create the sub views.
        getData()
    }
    
    /* Table View Functions. */
    
    // Set the number of rows in table view. It is simply equal to the number of players in the players array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    // Set up the table view cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell as a rankingTableCell.
        let cell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
        
        // Set the values for the ranking position, flag image, player name and statistic value.
        cell.positionLabel.text = String(indexPath.row + 1)
        cell.flagImage.image = UIImage(named: String((self.players[(indexPath as NSIndexPath).row]["RegionCode"]?.uppercased())! + ""))
        cell.nameLabel.text = self.players[(indexPath as NSIndexPath).row]["Name"]
        cell.statValueLabel.text = self.players[(indexPath as NSIndexPath).row][rankingType]
        
        // Load more data as the table view is scrolled down.
        // If the current row is within 20 rows from the bottom, add more rows to the bottom.
        if (indexPath.row == self.players.count - 20)
        {
            // Check whether the bottom has already been reached.
            // If it has, no more data needs to be called.
            if self.bottomReached == false {
                // Increment the currentStartPosition to get a new set of data.
                self.currentStartPosition += 50
            
                // Get the data in the background.
                DispatchQueue.global(qos: .background).async {
                    // Fetch the data from the API.
                    let morePlayers = getPlayerRankings(SortValue: self.rankingType, StartPosition: self.currentStartPosition, EndPosition: self.currentStartPosition + 50)
                    
                    // If there are no more players to get, the bottom has been reached.
                    if morePlayers.isEmpty == true {
                        self.bottomReached = true
                    }
                    
                    // This is called once the data has been fetched.
                    DispatchQueue.main.async {
                        // Append the new data to the old data.
                        self.players += morePlayers
                        // Reload the table view data.
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        // Return the cell.
        return cell
    }
    
    // Set the row height for the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // This is called when a row in the table view is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Highlight the row.
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the data of the selected player, and save it in the variable selectedPlayerData.
        self.selectedPlayerData = self.players[(indexPath as NSIndexPath).row]
        
        // Perform the segue to playerView, passing the data from the selected player.
        performSegue(withIdentifier: "rankingsPlayerSegue", sender: self)
    }
    
    // Adds the correct information during the segue to playerView.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rankingsPlayerSegue") {
            // Create a new playerView class.
            let playerClass = (segue.destination as! playerView)
            // Add the selectedPlayerData to the new class so it initialises with the selected player.
            playerClass.playerData = self.selectedPlayerData
        }
    }
    
    /* Data Functions */
    
    // Get the data.
    override func getData() {
        // Run in the background to prevent the UI from freezing.
        DispatchQueue.global(qos: .background).async {
            // Create the request.
            self.players = getPlayerRankings(SortValue: self.rankingType, StartPosition: self.currentStartPosition, EndPosition: self.currentStartPosition + 50)
            
            // Create a boolean which is true if the data is successfully received.
            var success: Bool!
            
            // If players is empty, then the data wasn't successfully received, so success should be set to false, and vice versa.
            if self.players.isEmpty == false {
                success = true }
            else {
                success = false }
            
            // Reload the table view and show the correct views.
            super.getData(success: success)
            
        }
    }
    
    // Called either when the table has been pulled down to reload it, or if the ranking type has been changed in the options menu.
    override func reloadData(sender: AnyObject) {
        
        // Reset the start position and bottom reached boolean.
        self.currentStartPosition = 0
        self.bottomReached = false
        
        // Set the new title to the ranking type if it has changed.
        self.title = self.rankingTitle
        
        // Get the data and reload the table view.
        super.reloadData(sender: self)
        
        // Scroll back to the top of the table view if needed.
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    /* createSubViews() */
    
    // Create all the subviews and add them to the main view.
    // Includes the main table view, as well as the column titles.
    override func createSubViews() {
        
        // Create player column.
        /*let playerLabel = UILabel(frame: CGRect(x: 95.0, y: Double((self.navigationController?.navigationBar.frame.height)! + 25.0), width: 100.0, height: 30.0))
        // Set the colour to white, add the text and add to view.
        playerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        playerLabel.text = "Player"
        playerLabel.textColor = UIColor.white
        playerLabel.alpha = 0.0
        
        // Create statistic label.
        let statlabel = UILabel(frame: CGRect(x: 200.0, y: Double((self.navigationController?.navigationBar.frame.height)! + 25.0), width: Double(self.view.frame.width - 220.0), height: 30.0))
        // Set the colour to white, add the text and add to view.
        statlabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        statlabel.text = self.rankingTitle
        statlabel.textAlignment = .right
        statlabel.textColor = UIColor.white
        statlabel.alpha = 0.0*/
        
        // Create the tableView with the data,
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 124))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = lightGrey
        self.tableView.alpha = 0.0
        
        // Add the refresh control.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.white
        self.tableView.addSubview(self.refreshControl)
        
        // Add the views in the correct order.
        //self.view.addSubview(playerLabel)
        //self.view.addSubview(statlabel)
        self.view.addSubview(self.tableView)
        self.view.bringSubview(toFront: self.navBar)
        
        // Fade the items in.
        /*UIView.animate(withDuration: 1.0, animations: {
            playerLabel.alpha = 1.0
            statlabel.alpha = 1.0
        })*/
        
        self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.tableView)
    }
    
    /* Other Functions */
    
    // Reload data when table view pulled down and released.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl.isRefreshing == true {
            self.reloadData(sender: self)
        }
    }
    
    // Called when the back button is pressed.
    @IBAction func optionButtonTouched(_ sender: AnyObject) {
        // Open/close the search bar.
        self.navBar.toggleView(type: .Options)
        
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
    
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
