//
//  rankingsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class rankingsView: templateViewController, UITableViewDelegate, UITableViewDataSource {
    
    // currentStartPosition holds the value used in the next call to the API. As the table is scrolled through, it is increased,
    // As players further down in the rankings need to be fetched.
    var currentStartPosition: Int = 0
    
    // bottomReached becomes true once the last players have been called, i.e. the table view has been scrolled all the way
    // To the bottom. This prevents excessive calls to the API.
    var bottomReached = false
    
    // Player data array and table view.
    var playerData = [[String: String]]()
    
    // Current menu open/last opened.
    var currentMenuType: menuType?
    
    
    /* viewDidLoad() */
    
    // Called as soon as the view loads.
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Rankings
        
        // Call viewDidLoad() in parent view controller.
        super.viewDidLoad()
        
        // Set the title.
        self.title = "Goals"
        
        // Set the navigation bar button to the options button.
        self.navigationItem.leftBarButtonItem = self.optionsButton
        
        // Get the data in the background, and once it has finished create all the sub views.
        getData()
    }
    
    /* Table View Functions. */
    
    // Set the number of rows in table view. It is simply equal to the number of players in the players array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerData.count
    }
    
    // Set up the table view cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell as a rankingTableCell.
        let cell: detailedRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(detailedRankingCell.self), for: indexPath) as! detailedRankingCell
        
        // Set the values for the ranking position, flag image, player name, statistic value, age and team.
        cell.positionLabel.text = String(indexPath.row + 1)
        cell.flagImage.image = UIImage(named: String((self.playerData[(indexPath as NSIndexPath).row]["RegionCode"]?.uppercased())! + ""))
        cell.nameLabel.text = self.playerData[(indexPath as NSIndexPath).row]["Name"]
        cell.statValueLabel.text = self.playerData[(indexPath as NSIndexPath).row][rankingType]
        cell.playingPositionValueLabel.text = self.playerData[(indexPath as NSIndexPath).row]["Age"]
        cell.teamValueLabel.text = self.playerData[(indexPath as NSIndexPath).row]["Team"]
        
        
        // Load more data as the table view is scrolled down.
        // If the current row is within 20 rows from the bottom, add more rows to the bottom.
        if (indexPath.row == self.playerData.count - 20)
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
                        self.playerData += morePlayers
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
        return 85.0
    }
    
    // This is called when a row in the table view is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Highlight the row.
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the data of the selected player, and save it in the variable selectedPlayerData.
        self.selectedPlayerData = self.playerData[(indexPath as NSIndexPath).row]
        
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
            self.playerData = getPlayerRankings(SortValue: self.rankingType, StartPosition: self.currentStartPosition, EndPosition: self.currentStartPosition + 50)
            
            // Create a boolean which is true if the data is successfully received.
            var success: Bool!
            
            // If players is empty, then the data wasn't successfully received, so success should be set to false, and vice versa.
            if self.playerData.isEmpty == false {
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
    }
    
    /* createSubViews() */
    
    // Create all the subviews and add them to the main view.
    // Includes the main table view, as well as the column titles.
    override func createSubViews() {
        
        // Create the table view.
        super.createSubViews()
        
        // Add the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Add table view cell.
        self.tableView.register(detailedRankingCell.self, forCellReuseIdentifier: NSStringFromClass(detailedRankingCell.self))
        
        // Add refresh control to table view.
        self.tableView.addSubview(self.refreshControl)
    }
    
    /* Other Functions */
    
    // Called when the view will disappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Reset the options button.
        self.navigationItem.setLeftBarButton(self.optionsButton, animated: true)
    }
    
    // Called when the right-hand navigation bar button is called.
    override func searchButtonTouched(_ sender: AnyObject) {
        
        // When the view is extended, hide the options button and show a close button on the right.
        // When the view is not extended, show both buttons.
        if self.navBar.viewExtended == true {
            self.navigationItem.setLeftBarButton(self.optionsButton, animated: true)
            self.navigationItem.setRightBarButton(self.searchButton, animated: true)}
        else {
            // If the view is not open, then search is being selected, so change the current menu variable accordingly.
            self.currentMenuType = .Search
            self.navigationItem.setRightBarButton(self.closeButton, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)}
        
        // Open/close the search/options menu depending on which one is currently active.
        if self.currentMenuType == .Options {
            self.navBar.toggleView(type: .Options)}
        else {
            self.navBar.toggleView(type: .Search)}
    }
    
    // Called when the left-hand navigation bar button is called.
    @IBAction func optionButtonTouched(_ sender: AnyObject) {
    
        // Change the buttons as described above depending on whether the menu is open or closed.
        if self.navBar.viewExtended == true {
            self.navigationItem.setRightBarButton(self.searchButton, animated: true)}
        else {
            // If the view is not open, then options is being selected, so change the current menu variable accordingly.
            self.currentMenuType = .Options
            self.navigationItem.setRightBarButton(self.closeButton, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)}
        
        // Open/close the search/options menu depending on which one is currently active.
        if self.currentMenuType == .Options {
            self.navBar.toggleView(type: .Options)}
        else {
            self.navBar.toggleView(type: .Search)}
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
