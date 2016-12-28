import UIKit

class favouritesView: templateViewController, UITableViewDelegate, UITableViewDataSource {

    // Player data array.
    var players = [[String: String]]()
    
    // Player image array.
    var playerImages = [String: UIImage]()
    
    // No players label. Shown if there are no players in favourites.
    var noPlayersLabel: UILabel!
    
    // Button on the left-hand side of the nav bar which allows the table view to be edited, i.e. remove players.
    var editButton: UIBarButtonItem!
    
    
    /* viewDidLoad() */
    
    // Called when the view loads.
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Favourites
        
        // Call viewDidLoad() in parent view controller.
        super.viewDidLoad()
        
        // Set the current page and title.
        self.title = "Favourites"
        
        // Create the no players label.
        self.noPlayersLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: (UIScreen.main.bounds.height / 2) - 15, width: 300, height: 30))
        // Set the colour to white, add the text and add to view.
        self.noPlayersLabel.font = UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightLight)
        self.noPlayersLabel.text = "No players in favourites"
        self.noPlayersLabel.textColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        self.noPlayersLabel.textAlignment = .center
        self.noPlayersLabel.alpha = 0.0
        self.view.addSubview(self.noPlayersLabel)
        
        // Create a nav bar button to allow editing.
        self.editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editTableView(_:)))
        self.editButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = self.editButton
    }
    
    /* viewWillAppear() */
    
    // Called when the view is about to appear.
    // Reloads the table view data, in case players have been added/removed from favourites.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        // Reload the data in the background to prevent the UI from freezing.
        self.getData()
        
        
        // Reset edit button if a player has been selected from search.
        self.navigationItem.setLeftBarButton(self.editButton, animated: true)
    }
    
    /* Table view functions */
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // Create cell.
        let rankingCell: imageRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(imageRankingCell.self), for: indexPath) as! imageRankingCell
        
        rankingCell.nameLabel.text = self.players[(indexPath as NSIndexPath).row]["Name"]
        rankingCell.teamLabel.text = self.players[(indexPath as NSIndexPath).row]["Team"]
        
        let image = UIImage(named: String((self.players[(indexPath as NSIndexPath).row]["RegionCode"]?.uppercased())! + ""))
        
        rankingCell.flagImage.image = image
        rankingCell.playerImage.image = self.playerImages[self.players[(indexPath as NSIndexPath).row]["PlayerId"]!]
        
        
        // Set cell.
        cell = rankingCell
        return cell
    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func editTableView(_ sender: AnyObject) {
        // Only allow editing if there are already players in favourites.
        if self.players.isEmpty == false {
            // Change the nav bar button depending on whether the editing is beginning or ending.
            if self.tableView.isEditing == true {
                self.navigationItem.leftBarButtonItem?.title = "Edit" }
            else {
                self.navigationItem.leftBarButtonItem?.title = "Done" }
            
            // Change the editing mode of the table view.
            self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        }
    }
    
    // Allows swipe to edit.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Called when a cell is edited.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        // If the cell is deleted.
        if editingStyle == .delete
        {
            DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            // Remove the selected player from favourites.
            removePlayerFromFavourites(self.players[(indexPath.row)]["PlayerId"]!)
            
            // Update players array.
            self.players.remove(at: indexPath.row)
            DispatchQueue.main.async {
                // Delete the row from the table view.
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                }
            // If there are no more players in favourites.
            if self.players.isEmpty == true {
                DispatchQueue.main.async {
                // Stop the table view from editing.
                self.tableView.isEditing = false
                
                // Reset the edit button.
                self.navigationItem.leftBarButtonItem?.title = "Edit"
                
                // Remove the table view and show the 'no players' label.
                self.transitionBetweenViews(firstView: self.tableView, secondView: self.noPlayersLabel, removeFirstView: false)
                }
                
            }
            }
        }
    }
    
    // Player selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedPlayerData = self.players[(indexPath as NSIndexPath).row]
        
        performSegue(withIdentifier: "favouritesPlayerSegue", sender: self)
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favouritesPlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
            
        }
    }
    
    /* createSubViews() */
    
    // Initiate all the subViews, and fade them in.
    override func createTableView() {
        
        // Create the table view.
        super.createTableView()
        
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Add table view cells.
        self.tableView.register(imageRankingCell.self, forCellReuseIdentifier: NSStringFromClass(imageRankingCell.self))
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    /* Data Functions */
    
    // Gets the data, including the images, for all the players in favourites.
    override func getData() {
        
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
    
            // Get players data from CoreData.
            self.players = getPlayersFromFavourites()
            
            // Check whether there are any players in favourites.
            if self.players.count != 0 {
                // If there is, create the table view in the background, as the images must be fetched.
                // If the view hasn't been initialised, i.e. this is the first time it has been called, create all subviews.
                if self.viewInitialised == false {
                    self.getImages()
                    DispatchQueue.main.async {
                        self.createTableView()
                        self.viewInitialised = true
                    }
                }
                // Otherwise, get the images and reload the table view.
                else {
                    self.getImages()
                    DispatchQueue.main.async {
                        // Remove the no players label if needed, and make sure the alpha of the table view is 1.0.
                        self.transitionBetweenViews(firstView: self.noPlayersLabel, secondView: self.tableView, removeFirstView: false)
                    
                        // Reload the table view.
                        UIView.transition(with: self.tableView, duration: 0.25, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                    }
                }
            }
            // Otherwise display an error message saying there are no players in favourites.
            else {
                DispatchQueue.main.async {
                    // Remove the activity indicator.
                    self.activityIndicator.removeFromSuperview()
                    
                    // Reload the table view.
                    self.tableView.reloadData()
            
                    // Remove the table view, and show the no players label.
                    self.transitionBetweenViews(firstView: self.tableView, secondView: self.noPlayersLabel, removeFirstView: false)
                }
            }
        }
    }
    
    // Gets the image for all the players in self.players.
    // It only gets the images needed; ones which have already been loaded won't be fetched again.
    func getImages() {
        
        // Create a temporary dictionary to hold the player images.
        // This prevents images which have already been loaded being loaded again. Only the new players which have been added
        // Will have to have their image fetched from the server.
        var tempImages = [String: UIImage]()

        // Loop through each player which will be in the table view.
        for player in self.players {
            // If their image has already been received, add it to the temp dictionary.
            if let image = self.playerImages[player["PlayerId"]!] {
                tempImages[player["PlayerId"]!] = image
            }
            // Otherwise, fetch the image from the server and add it to the temp dictionary.
            else {
                // Add it to the temp dictionary.
                tempImages[player["PlayerId"]!] = getImage(url: player["PhotoUrl"]!, type: .Player)
            }
        }
            
        // Set playerImages to the temp dictionary.
        self.playerImages = tempImages
        
    }
    
    /* Other Functions */
    
    // Remove the edit button when searching.
    override func searchButtonTouched(_ sender: AnyObject) {
        super.searchButtonTouched(self)
        
        // If the view is extended a search is active so remove the edit button.
        if self.navBar.viewExtended == true {
            self.navigationItem.setLeftBarButton(nil, animated: true)}
        // Otherwise add it back.
        else {
            self.navigationItem.setLeftBarButton(self.editButton, animated: true)}
    }
    
    // Prevent refresh control being called when scrolling.
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
