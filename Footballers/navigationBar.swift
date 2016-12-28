import UIKit

/* Navigation Bar Class */

class navigationBar: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Set the type of the navigation which varies depending on whether it is for home, rankings or favourites view.
    var type: viewType
    
    // Create a view controller object to allow for segues after players have been selected from search.
    var viewController: templateViewController!
    
    // Boolean which is true when the view is extended down, and false otherwise.
    var viewExtended: Bool! = false
    
    // Boolean which is true when text has been typed in the search bar, i.e. a search is active.
    var noResults: Bool! = false
    
    // Float which stores the height of the screen, to handle screens of different sizes.
    // Passed from the view controller which instantiates the class.
    var frameHeight: CGFloat!
    
    // Search field and cancel button.
    var searchField: UITextField = UITextField()
    var cancelButton: UIButton = UIButton()
    var noResultsLabel: UILabel = UILabel()
    
    // Divider line.
    var divider: UIImageView = UIImageView()
    
    // Table views.
    var searchTableView: UITableView = UITableView()
    var optionsTableView: UITableView = UITableView()
    
    // Player data.
    var searchedPlayers: [[String: String]] = [[String: String]]()
    
    // The PlayerId needed for a segue when a player is selected.
    var selectedPlayerData = [String: String]()

    // Option values for rankings view.
    // The first element in each sub-array is the name of the option which will appear on the screen, and the second element
    // Is the name of the value needed for the call to the API.
    var optionValues: [[String]] = [
            ["Goals", "Goals"],
            ["Assists", "Assists"],
            ["Appearances", "Games"],
            ["Minutes Played", "Minutes"],
            ["Yellow Cards", "YellowCards"],
            ["Red Cards", "RedCards"],
            ["Shots on Target (%)", "ShotSuccess"],
            ["Passes Completed (%)", "PassSuccess"],
            ["Tackles Won per Game", "TacklesWon"],
            ["Age", "Age"],
            ["Height (cm)", "Height"],
            ["Weight (kg)", "Weight"]
    ]
    
    // Queue to load search results serially.
    var queue: OperationQueue!
    

    /* init() */
    
    // Called when the view initiates.
    init (frame : CGRect, type: viewType) {
        
        // Set the value for view type.
        self.type = type
        
        // Initiate the class.
        super.init(frame : CGRect(x: -1, y: 0, width: frame.width + 1, height: 64))
        
        // Keep all subviews within the nav bar view.
        self.clipsToBounds = true
    
        // Set the screen height.
        self.frameHeight = frame.height
        
        // Set the default background colour.
        self.backgroundColor = darkGrey
        
        // Create the search bar, cancel button and search table view.
        createSearchBar()
        
        // If a search is already active in another view when this view is initiated, copy the search results over.
        if currentSearchText != "" {
            updateSearchBar()
        }
        
        // Create the options table view only if the nav bar is for rankings view.
        if self.type == .Rankings {
            createOptionsTable()
        }
        
        // Initialise the queue.
        self.queue = OperationQueue()
        
    }
    
    /* Table view functions */
    
    // Set the number of rows in the tableView, depending on which menu is open.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Search table view.
        if tableView == self.searchTableView {
            return self.searchedPlayers.count
        }
        // Options table view.
        else {
            return self.optionValues.count
        }
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell?
        
        // Search table view cell.
        if tableView == self.searchTableView {
            
            // Set the cell type and background colour.
            cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            // Set the player name and font size/colour.
            cell?.textLabel?.text = self.searchedPlayers[(indexPath as NSIndexPath).row]["Name"]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
            
            // Set the player flag image.
            cell!.imageView?.image = UIImage(named: String(searchedPlayers[(indexPath as NSIndexPath).row]["RegionCode"]!).uppercased())
        }
            
        // Options table view cell.
        else {
            
            // Set the cell type and background colour.
            cell = self.optionsTableView.dequeueReusableCell(withIdentifier: "optionsCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            // Set the option value and font size/colour.
            cell?.textLabel?.text = self.optionValues[indexPath.row][0]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:18)
        }
        
        // Return the cell.
        cell?.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell!
    }
    
    // Set the row height for all table views to 40.0.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Called when a tableViewCell is selected, i.e. a player has been clicked on or an option has been selected.
    // If a player has been selected, open their player view.
    // If an option has been selected, close the nav bar and reload the data in the table view with the new ranking type.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Search table view cell selected.
        if tableView == self.searchTableView {
            
            // Select the correct PlayerId depending on which tableView the selected cell is in.
            let playerData: [String: String]
            
            // Dissmiss keyboard and open player view controller.
            self.searchField.resignFirstResponder()
            playerData = searchedPlayers[(indexPath as IndexPath).row]
            
            // Assign value to selectedPlayerData.
            self.selectedPlayerData = playerData
            
            // Set the view controller's player data to the selected one.
            self.viewController.selectedPlayerData = playerData
            
            // Perform a different segue depending on the view type of the nav bar.
            var identifier: String!
            
            // Perform the segue to the player view.
            switch self.type {
            case .Home:
                identifier = "homePlayerSegue"
            case .Rankings:
                identifier = "rankingsPlayerSegue"
            case .Favourites:
                identifier = "favouritesPlayerSegue"
            default: break
            }
            
            // Perform the segue.
            self.viewController.performSegue(withIdentifier: identifier, sender: self.viewController)
            
        }
           
        // Options table view cell selected.
        else {
            // Set the view controller's ranking type and title to the selected one.
            self.viewController.rankingType = self.optionValues[indexPath.row][1]
            self.viewController.rankingTitle = self.optionValues[indexPath.row][0]
            
            // Hide the view controller's table view and bring up the loading activity indicator so that the data can be reloaded.
            self.viewController.tableView.alpha = 0.0
            self.viewController.activityIndicator.alpha = 1.0
            
            // Reload the data with the new ranking type.
            self.viewController.reloadData(sender: self)
            
            // Set the navigation bar button back to the search button.
            self.viewController.navigationItem.setRightBarButton(self.viewController.searchButton, animated: true)
            
            // Set the navigation bar button back to the config button.
            self.viewController.navigationItem.setLeftBarButton(self.viewController.optionsButton, animated: true)
            
            // Close the nav bar.
            toggleView(type: .Options)
        }
        
        // Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /* Toggle View Function */
    
    // Toggle view is called when either the search button or the options button on the nav bar are pressed.
    // It extends the view down and brings up either the search bar, or the options menu depending on which button was pressed.
    func toggleView(type: menuType) {
        
        // If search button was pressed, remove the options menu and bring up the views relevant to the search.
        if type == .Search {
            self.addSubview(self.searchField)
            self.addSubview(self.divider)
            self.addSubview(self.searchTableView)
            self.addSubview(self.noResultsLabel)
            self.optionsTableView.removeFromSuperview()
        }
        // Otherwise the options button was pressed, so bring up the options menu and remove everything else.
        else {
            self.addSubview(self.optionsTableView)
            self.searchField.removeFromSuperview()
            self.divider.removeFromSuperview()
            self.searchTableView.removeFromSuperview()
            self.noResultsLabel.removeFromSuperview()
        }
        
        // Switch values for fading items in/out and extending the view depending on whether it is already extended.
        var height: CGFloat!
        var alpha: CGFloat!
        
        // If the view is currently closed, views need to be faded in, and the menu needs to be extended to the bottom of the view.
        if self.viewExtended == false {
            height = self.frameHeight
            alpha = 1.0 }
        // Otherwise the views need to be faded out, and the menu needs to be brought back up to the height of the nav bar, which is 64 pixels.
        else {
            height = 64
            alpha = 0.0
        }
        
        // Animate the transition.
        UIView.animate(withDuration: 0.3, animations: {
            // Change the view size.
            self.frame = CGRect(x: -1, y: 0, width: self.frame.width, height: height)
            
            // Only change the search bar and divider as the table view and no results label may have been deliberately hidden,
            // For example if a search is in progress and there are no results the no results label needs to have alpha = 1.0,
            // And the table view needs alpha = 0.0.
            if type == .Search {
                self.searchField.alpha = alpha
                self.divider.alpha = alpha
            }
            // The options table view always needs to be fade in/out.
            else {
                self.optionsTableView.alpha = alpha
            }
            // Once the animation is complete, if the search menu is active, bring the keyboard up/remove it.
            }, completion: { (complete: Bool) in
                if type == .Search {
                    // Remove or bring up the keyboard.
                    if self.viewExtended == false {
                        self.searchField.resignFirstResponder() }
                    else {
                        self.searchField.becomeFirstResponder()
                    }
                }
        })
        
        // Negate the viewExtended variable.
        self.viewExtended = !self.viewExtended
        
    }
    
    /* Create View Functions */
    
    // Create the search bar, divider, no results label and search table views.
    // These are all the views needed for the search.
    func createSearchBar() {
        
        // Create search bar.
        self.searchField.frame = CGRect(x: 15, y: 60, width: self.frame.width - 30, height: 50)
        // Set the placeholder text.
        self.searchField.attributedPlaceholder = NSAttributedString(string:"Search for players...",
                                                                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        // Set attributes.
        self.searchField.autocorrectionType = UITextAutocorrectionType.no
        self.searchField.clearButtonMode = UITextFieldViewMode.whileEditing
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.searchField.returnKeyType = UIReturnKeyType.done
        // Call textFieldDidChange when a character is inputed/deleted.
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        // Set the font and colour.
        self.searchField.font = UIFont.systemFont(ofSize: 18)
        self.searchField.textColor = UIColor.white
        self.searchField.tintColor = UIColor.white
        // Prevent non-ascii characters from being inputted, such as emojis.
        self.searchField.keyboardType = UIKeyboardType.asciiCapable;
        // Initialise it with alpha = 0.0.
        self.searchField.alpha = 0.0
        
        // Create the divider.
        self.divider.image = UIImage(named: "whiteLine.png")
        self.divider.frame = CGRect(x: 15.0, y: 110.0, width: self.frame.width - 30, height: 0.5)
        self.divider.alpha = 0.0
        
        // Create no results label.
        self.noResultsLabel.frame = CGRect(x: 15, y: 150, width: self.frame.width - 30, height: 35)
        self.noResultsLabel.textAlignment = .center
        // Set the font and colour.
        self.noResultsLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightLight)
        self.noResultsLabel.textColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        self.noResultsLabel.backgroundColor = UIColor.clear
        // Set the text.
        self.noResultsLabel.text = "No results"
        self.noResultsLabel.alpha = 0.0
        
        // Create search table view.
        self.searchTableView.frame = CGRect(x: 0, y: 120, width: self.frame.width, height: self.frameHeight - 174)
        // Set attributes.
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = UIColor.clear
        self.searchTableView.rowHeight = 40.0
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.searchTableView.alpha = 1.0
        
        // Add views in correct order.
        self.addSubview(self.searchTableView)
        self.addSubview(self.searchField)
        self.addSubview(self.cancelButton)
        self.addSubview(self.divider)
        self.addSubview(self.noResultsLabel)
        
    }
    
    // Create the options table view, which is the only thing needed for the options menu.
    func createOptionsTable() {
        
        // Create options table view.
        self.optionsTableView.frame = CGRect(x: 0, y: 80, width: self.frame.width, height: self.frameHeight - 174)
        self.optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionsCell")
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        self.optionsTableView.alwaysBounceVertical = false
        self.optionsTableView.backgroundColor = UIColor.clear
        self.optionsTableView.rowHeight = 40.0
        self.optionsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.optionsTableView.alpha = 0.0
        
        // Add the table view to view.
        self.addSubview(self.optionsTableView)
        
    }
    
    /* Search bar functions */
    
    // Update the search bar with the current text being inputted, and bring up search results in the search table view.
    func updateSearchBar() {
        
        // Update the data and reload the table view.
        self.searchField.text = currentSearchText
        self.searchedPlayers = currentSearchedPlayers
        self.searchTableView.reloadData()
        
        // If there are no results, show the no results label.
        if self.searchedPlayers.count == 0 && self.searchField.text != "" {
            self.noResults = true
            self.noResultsLabel.alpha = 1.0
            self.searchTableView.alpha = 0.0
        }
        else {
            self.noResults = false
            self.noResultsLabel.alpha = 0.0
            self.searchTableView.alpha = 1.0
        }
    }
    
    // Called whenever something changes in the text field, i.e. a character has been typed in/deleted.
    func textFieldDidChange(_ textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        currentSearchText = textField.text!
        
        // Cancel any pending operations.
        self.queue.cancelAllOperations()
        
        // Define the operation.
        let getSearchResult = BlockOperation()
        
        // Create the request in the background to prevent any delay.
        getSearchResult.addExecutionBlock {
        
            // If the text hasn't been cleared, check if it matches any players.
            if string != "" {
            
                // Get the data.
                self.searchedPlayers = searchForPlayer(SearchString: string!)
                currentSearchedPlayers = self.searchedPlayers
                
                // If there are no results from the search.
                if self.searchedPlayers.count == 0 {
                    
                    // Set noResults to true.
                    self.noResults = true
                    
                    // Before updating the view, make sure the operation hasn't been canceled.
                    if !getSearchResult.isCancelled {
                        
                        // Execute on the main thread.
                        OperationQueue.main.addOperation({
                        
                            // Fade out the table view, and fade in the no results label.
                            UIView.animate(withDuration: 0.25, animations: {
                                self.searchTableView.alpha = 0.0
                                self.noResultsLabel.alpha = 1.0
                            }, completion: { (complete: Bool) in
                                self.searchTableView.reloadData()
                            })
                        })
                    }
                }
                    
                // If there are results from the search.
                else {
                    
                    // Set noResults to false.
                    self.noResults = false
                    
                    // Before updating the view, make sure the operation hasn't been canceled.
                    if !getSearchResult.isCancelled {
                        
                        // Execute on the main thread.
                        OperationQueue.main.addOperation({
                            
                            // Bring back the table view and remove the no results label if needed.
                            if self.searchTableView.alpha == 0 {
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.searchTableView.alpha = 1.0
                                    self.noResultsLabel.alpha = 0.0
                                })
                            }
                            
                            // Reload the table view data.
                            UIView.transition(with: self.searchTableView, duration: 0.25, options: .transitionCrossDissolve, animations: {self.searchTableView.reloadData()}, completion: nil)
                            })
                        }
                    }
                }
            
        // If the text is empty or been cleared give an empty array.
        else {
            
            // Set noResults to false.
            self.noResults = false
            
            // Empty searchedPlayers.
            self.searchedPlayers = []
            currentSearchedPlayers = self.searchedPlayers
            
                // Before updating the view, make sure the operation hasn't been canceled.
            if !getSearchResult.isCancelled {
                
                // Execute on the main thread.
                OperationQueue.main.addOperation({
                    
                    // Reload the table view with an animation.
                    UIView.animate(withDuration: 0.25, animations: {
                        self.searchTableView.alpha = 0.0
                        self.noResultsLabel.alpha = 0.0
                    }, completion: { (complete: Bool) in
                        self.searchTableView.reloadData()
                        })
                    })
                }
            }
        }
        
        // Add the operation to the queue.
        self.queue.addOperation(getSearchResult)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
