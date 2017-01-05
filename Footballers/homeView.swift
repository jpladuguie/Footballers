import UIKit

class homeView: templateViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare data variables for the view.
    var topScorersData = [[String: String]]()
    var topAssistsData = [[String: String]]()
    var topDefenderData = [[String: String]]()
    var topPlayersData = [[String: String]]()
    
    // Image for the top defender.
    var topDefenderImage: UIImage!
    
    
    /* viewDidLoad() */
    
    // Called when the view loads.
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Home
        
        // Call viewDidLoad() in parent view controller.
        super.viewDidLoad()
        
        // Set the title.
        self.title = "Home"
        
        // Get the data in the background, and once it has finished create all the sub views.
        getData()
    }
    
    /* Table View Functions */
    
    // Set the number of rows in the table view.
    // 19 are needed:
    //  - Top Scorers title
    //  - 5 for the top scorers
    //  - Divider
    //  - Most Assists title
    //  - 3 for the most assists
    //  - Divider
    //  - Best Passer title
    //  - Best Passer cell
    //  - Divider
    //  - In Form Players title
    //  - 3 for in form players
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the row.
        let row = (indexPath as NSIndexPath).row
        
        // Create cell.
        var cell:UITableViewCell?
        
        // Top Scorers title cell.
        if row == 0 {
            
            // Create a cell from the titleCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            // Set the title.
            title.titleLabel.text = "Top Scorers"
                
            // Set the main cell to the new one.
            cell = title
        }
        
        // Top Scorer cells.
        else if row > 0 && row < 6 {
            
            // Create the custom cell using the playerCell class.
            let topScorerCell: playerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerCell.self), for: indexPath) as! playerCell
            
            // Set the selection style.
            topScorerCell.selectionStyle = .gray
            
            // Set the position label.
            topScorerCell.positionLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
            topScorerCell.positionLabel.text = String(row)
            topScorerCell.contentView.addSubview(topScorerCell.positionLabel)
            
            // Set the flag image.
            topScorerCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
            topScorerCell.flagImage.image = UIImage(named: String((self.topScorersData[row - 1]["RegionCode"]?.uppercased())! + "")!)!
            topScorerCell.contentView.addSubview(topScorerCell.flagImage)
            
            // Set the name label.
            topScorerCell.nameLabel.frame = CGRect(x: 75, y: 0, width: UIScreen.main.bounds.width - 100, height: 40)
            topScorerCell.nameLabel.text = self.topScorersData[row - 1]["Name"]
            topScorerCell.contentView.addSubview(topScorerCell.nameLabel)
            
            // Stat the value label.
            topScorerCell.valueLabel.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 0, width: 50, height: 40)
            topScorerCell.valueLabel.text = self.topScorersData[row - 1]["Goals"]
            topScorerCell.addSubview(topScorerCell.valueLabel)
            
            // Set the cell.
            cell = topScorerCell
        }
        
        // Most Assists title cell.
        else if row == 7 {
            
            // Create a cell from the titleCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            // Set the title
            title.titleLabel.text = "Most Assists"
                
            // Set the main cell to the new one.
            cell = title
        }
            
        // Most Assist cells.
        else if row > 7 && row < 11 {
            
            // Create a cell from the playerCell class.
            let mostAssistsCell: playerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerCell.self), for: indexPath) as! playerCell
            
            // Set selection style.
            mostAssistsCell.selectionStyle = .gray
            
            // Set the name label.
            mostAssistsCell.nameLabel.frame = CGRect(x: 20, y: 0, width: ((UIScreen.main.bounds.width / 3) * 2), height: 35)
            mostAssistsCell.nameLabel.text = self.topAssistsData[row - 8]["Name"]
            mostAssistsCell.contentView.addSubview(mostAssistsCell.nameLabel)
            
            // Set the value label.
            mostAssistsCell.valueLabel.frame = CGRect(x: ((UIScreen.main.bounds.width / 3) * 2), y: 0, width: (UIScreen.main.bounds.width / 3) - 20, height: 35)
            mostAssistsCell.valueLabel.text = self.topAssistsData[row - 8]["Assists"]
            mostAssistsCell.contentView.addSubview(mostAssistsCell.valueLabel)
            
            // Set the rating bar.
            mostAssistsCell.contentView.addSubview(mostAssistsCell.ratingBar)
            
            // Get the rating value as a float.
            let ratingValue = Float(self.topAssistsData[row - 8]["Assists"]!)! / Float(self.topAssistsData[0]["Assists"]!)! * 100.0
            
            // Get the bar width depending on the value and the screen width.
            // The larger the value, the longer the bar.
            let barWidth: Int = Int(Float(ratingValue * Float(self.view.frame.width - 40)) / 100.0)
            
            // Set the bar's colour depending on the strength of the rating.
            mostAssistsCell.ratingBar.backgroundColor = getRatingColour(value: Int(ratingValue))
            
            // Animate the rating bar so that it slides in.
            UIView.animate(withDuration: 1.0, animations: {
                mostAssistsCell.ratingBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
            })
            
            // Set the main cell to the new one.
            cell = mostAssistsCell
        }
        
        // Divider cell.
        else if (indexPath as NSIndexPath).row == 11 {
            
            // Create a cell from the dividerCell class.
            let divider: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            // Set custom divider position.
            divider.divider.frame = CGRect(x: 20.0, y: 32.5, width: UIScreen.main.bounds.width - 40, height: 0.5)
            
            // Set the main cell to the new one.
            cell = divider
        }
        
        // Best Defender title cell.
        else if (indexPath as NSIndexPath).row == 12 {
            
            // Create a cell from the titleCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            // Set the title
            title.titleLabel.text = "Best Defender"
            
            // Set the main cell to the new one.
            cell = title
        }
        
        // Best Defender cell.
        else if (indexPath as NSIndexPath).row == 13 {
            
            // Create cell.
            let topDefenderCell: imageRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(imageRankingCell.self), for: indexPath) as! imageRankingCell
            
            // Set the values of the player's name, team, flag image and image.
            topDefenderCell.nameLabel.text = self.topDefenderData[0]["Name"]
            topDefenderCell.teamLabel.text = self.topDefenderData[0]["Team"]
            topDefenderCell.flagImage.image = UIImage(named: String((self.topDefenderData[0]["RegionCode"]?.uppercased())! + ""))
            topDefenderCell.playerImage.image = self.topDefenderImage
            
            // Set the main cell to the new one.
            cell = topDefenderCell
        }
         
        // In Form Players title cell.
        else if (indexPath as NSIndexPath).row == 15 {
            
            // Create a cell from the titleCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            // Set the title.
            title.titleLabel.text = "In Form Players"
            
            // Set the main cell to the new one.
            cell = title
        }
            
        // In Form player cells.
        else if (indexPath as NSIndexPath).row > 15 && (indexPath as NSIndexPath).row < 19 {
            
            // Create the cell as a detailedRankingCell.
            let detailedCell: detailedRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(detailedRankingCell.self), for: indexPath) as! detailedRankingCell
            
            // Set the values for the ranking position, flag image, player name, statistic value, age and team.
            detailedCell.positionLabel.text = String(row - 15)
            detailedCell.flagImage.image = UIImage(named: String((self.topPlayersData[row - 16]["RegionCode"]?.uppercased())! + ""))
            detailedCell.nameLabel.text = self.topPlayersData[row - 16]["Name"]
            detailedCell.ageLabel.text = self.topPlayersData[row - 16]["Age"]
            detailedCell.teamLabel.text = self.topPlayersData[row - 16]["Team"]
            
            // Set the main cell to the new one.
            cell = detailedCell
        }
        
        // Otherwise any other cells should be divider cells.
        else {
            
            // Create a cell from the dividerCell class.
            let divider: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            // Set the main cell to the new one.
            cell = divider
        }
        
        // Set the cells anchor point to prevent it moving unexpectedly, and return it.
        cell?.layer.anchorPointZ = CGFloat(row)
        return cell!
    }
    
    // Set the row height for the table view cells depending on which cell they are.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Depending on which cell is being used vary the height. The heights for the various cells are:
        //  - Title - 40.0
        //  - Top Scorers - 40.0
        //  - Most Assists - 50.0
        //  - Best Defender - 85.0
        //  - In Form Players - 85.0
        // In addition to the custom divider which is 45.0.
        switch (indexPath as NSIndexPath).row {
        case 6:
            return 20.0
        case 8..<11:
            return 50.0
        case 11:
            return 45.0
        case 13:
            return 85.0
        case 14:
            return 20.0
        case 16..<19:
            return 85.0
        default:
            return 40.0
        }
        
    }
    
    // This is called when a row in the table view is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the row of the cell which was selected.
        let row = (indexPath as NSIndexPath).row
        
        // Depending on which player was selected, open the correct player view.
        switch row {
        // Top Scorers.
        case 1..<6:
            self.selectedPlayerData = self.topScorersData[(indexPath as NSIndexPath).row - 1]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        // Most Assists.
        case 8..<11:
            self.selectedPlayerData = self.topAssistsData[(indexPath as NSIndexPath).row - 8]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        // Best Defender.
        case 13:
            self.selectedPlayerData = self.topDefenderData[0]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        // In Form Players.
        case 16..<19:
            self.selectedPlayerData = self.topPlayersData[(indexPath as NSIndexPath).row - 16]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        // Any other cell, such as title cells or dividers should not do anything when selected.
        default: break
        }
        
    }
    
    // Called when a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // When a player has been selected, send the correct PlayerId to the playerView.
        let playerClass = (segue.destination as! playerView)
        playerClass.playerData = self.selectedPlayerData
    }
    
    /* Data Functions */
    
    // Get the data.
    override func getData() {
        
        // Cancel any pending operations.
        self.queue.cancelAllOperations()
        
        // Define the operation.
        self.getDataOperation = BlockOperation()
        
        // Run in the background to prevent the UI from freezing.
        getDataOperation.addExecutionBlock {
            
            // Create the request.
            self.topScorersData = getPlayerRankings(SortValue: "Goals", StartPosition: 0, EndPosition: 5)
            self.topAssistsData = getPlayerRankings(SortValue: "Assists", StartPosition: 0, EndPosition: 3)
            self.topDefenderData = getPlayerRankings(SortValue: "DefendingRating", StartPosition: 0, EndPosition: 1)
            self.topPlayersData = getPlayerRankings(SortValue: "OverallRating", StartPosition: 0, EndPosition: 3)
            
            // Create a boolean which is true if the data is successfully received.
            var success: Bool!
            
            // If topScorersData is empty, then the data wasn't successfully received, so success should be set to false, and vice versa.
            if self.topScorersData.isEmpty == false {
                success = true
                // If the data has been successfully received, get any images needed.
                self.topDefenderImage = self.getImage(url: self.topDefenderData[0]["PhotoUrl"]!, type: .Player) }
            else {
                success = false }
            
            // Reload the table view and show the correct views using the parent function.
            super.getData(success: success)
            
        }
        
        // Add the operation to the queue top run in the background.
        self.queue.addOperation(self.getDataOperation)
    }
    
    /* createSubViews() */
    
    // Initiate all the subViews, and fade them in.
    override func createTableView() {
        
        // Create the table view.
        super.createTableView()
        
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Remove separators.
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Add table view cells.
        self.tableView.register(titleCell.self, forCellReuseIdentifier: NSStringFromClass(titleCell.self))
        self.tableView.register(dividerCell.self, forCellReuseIdentifier: NSStringFromClass(dividerCell.self))
        self.tableView.register(playerCell.self, forCellReuseIdentifier: NSStringFromClass(playerCell.self))
        self.tableView.register(imageRankingCell.self, forCellReuseIdentifier: NSStringFromClass(imageRankingCell.self))
        self.tableView.register(detailedRankingCell.self, forCellReuseIdentifier: NSStringFromClass(detailedRankingCell.self))
        
        // Add refresh control to table view.
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    /* Other Functions */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
