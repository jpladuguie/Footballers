//
//  navigationBar.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 17/12/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class navigationBar: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Set the type of the navigation which varies depending on whether it is for home, rankings or favourites view.
    var type: viewType
    
    //
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
    
    // Table views.
    var searchTableView: UITableView = UITableView()
    var optionsTableView: UITableView = UITableView()
    
    // Player data.
    var searchedPlayers: [[String: String]] = [[String: String]]()
    
    // The PlayerId needed for a segue when a player is selected.
    var selectedPlayerData = [String: String]()
    
    // Divider line.
    var divider: UIImageView = UIImageView()
    

    
    var optionValues: [[String]]!
    
    
    // Called when the view initiates.
    override init (frame : CGRect) {
        
        // Default value for type.
        self.type = .Home
        
        // Initiate the class.
        super.init(frame : CGRect(x: -1, y: 0, width: frame.width + 1, height: 64))
        
        self.optionValues = [
            ["Goals", "Goals"],
            ["Assists", "Assists"],
            ["Appearances", "Games"],
            ["Minutes Played", "Minutes"],
            ["Yellow Cards", "YellowCards"],
            ["Red Cards", "RedCards"],
            ["Shots on Target", "ShotSuccess"],
            ["Passes Completed", "PassSuccess"],
            ["Tackles Won per Game", "TacklesWon"],
            ["Age", "BirthDate"],
            ["Height", "Height"],
            ["Weight", "Weight"]
        ]
        
        
        // Set the screen height.
        self.frameHeight = frame.height
        
        // Set the default background colour.
        self.backgroundColor = darkGrey
        
        // Create the search bar, cancel button and search table view.
        createSearchBar()
        
        if self.type == .Rankings {
            createOptionsTable()
        }
        
    }
    
    // Called when the search icon is pressed.
    func toggleSearch() {
        
        // Switch values for fading items in/out and extending the view depending on whether it is already extended.
        var height: CGFloat!
        var alpha: CGFloat!
        
        if self.viewExtended == false {
            height = self.frameHeight
            alpha = 1.0 }
        else {
            height = 64
            alpha = 0.0
        }
        
        // Fade items in.
        UIView.animate(withDuration: 0.3, animations: {
            // Change view size.
            self.frame = CGRect(x: -1, y: 0, width: self.frame.width, height: height)
            
            // Fade search bar and table view in/out.
            
            
            self.searchField.alpha = alpha
            self.divider.alpha = alpha
            
            if self.viewExtended == false {
                if self.noResults == true {
                    self.searchTableView.alpha = 0.0
                    self.noResultsLabel.alpha = 1.0
                }
                
                else {
                    self.searchTableView.alpha = 1.0
                    self.noResultsLabel.alpha = 0.0
                }
            }
            else {
                self.searchTableView.alpha = 0.0
                self.noResultsLabel.alpha = 0.0
            }
            
            
            }, completion: { (complete: Bool) in
                // Remove or bring up the keyboard.
                if self.viewExtended == false {
                    self.searchField.resignFirstResponder() }
                else {
                    self.searchField.becomeFirstResponder()
                }
        })
        
        // Negate the viewExtended variable.
        self.viewExtended = !self.viewExtended
        
    }
    
    func toggleOptions() {
        // Switch values for fading items in/out and extending the view depending on whether it is already extended.
        var height: CGFloat!
        var alpha: CGFloat!
        
        if self.viewExtended == false {
            height = self.frameHeight
            alpha = 1.0 }
        else {
            height = 64
            alpha = 0.0
        }
        
        // Fade items in.
        UIView.animate(withDuration: 0.3, animations: {
            // Change view size.
            self.frame = CGRect(x: -1, y: 0, width: self.frame.width, height: height)
            }, completion: { (complete: Bool) in
            
                self.optionsTableView.alpha = alpha
        })
        
        // Negate the viewExtended variable.
        self.viewExtended = !self.viewExtended
    }
    
    func createSearchBar() {
        
        // Create search bar.
        self.searchField.frame = CGRect(x: 15, y: 60, width: self.frame.width - 30, height: 50)
        self.searchField.autocorrectionType = UITextAutocorrectionType.no
        self.searchField.attributedPlaceholder = NSAttributedString(string:"Search for players...",
                                                                    attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.searchField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.searchField.keyboardType = UIKeyboardType.default
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.searchField.font = UIFont.systemFont(ofSize: 18)
        self.searchField.textColor = UIColor.white
        self.searchField.returnKeyType = UIReturnKeyType.done
        self.searchField.addTarget(self, action: #selector(navigationBar.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.searchField.tintColor = UIColor.white
        self.searchField.keyboardType = UIKeyboardType.asciiCapable;
        self.searchField.alpha = 0.0
        
        // Create cancel button for search bar.
        self.cancelButton = UIButton(frame: CGRect(x: self.frame.width - 70, y: 64, width: 60, height: 50))
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.alpha = 0.0
        
        // Create the divider.
        self.divider.image = UIImage(named: "whiteLine.png")
        self.divider.frame = CGRect(x: 15.0, y: 110.0, width: self.frame.width - 30, height: 1.0)
        self.divider.alpha = 0.0
        
        // Create no results label.
        self.noResultsLabel.frame = CGRect(x: 15, y: 150, width: self.frame.width - 30, height: 35)
        self.noResultsLabel.textAlignment = .center
        self.noResultsLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightUltraLight)
        self.noResultsLabel.textColor = UIColor.white
        self.noResultsLabel.backgroundColor = UIColor.clear
        self.noResultsLabel.text = "No results."
        self.noResultsLabel.alpha = 0.0
        
        // Create search tableview.
        self.searchTableView.frame = CGRect(x: 0, y: 120, width: self.frame.width, height: self.frameHeight - 174)
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = UIColor.clear
        self.searchTableView.alpha = 0.0
        self.searchTableView.rowHeight = 40.0
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Add views in correct order.
        self.addSubview(self.searchTableView)
        self.addSubview(self.searchField)
        self.addSubview(self.cancelButton)
        self.addSubview(self.divider)
        self.addSubview(self.noResultsLabel)
        
    }
    
    func createOptionsTable() {
        
        // Create search tableview.
        self.optionsTableView.frame = CGRect(x: 0, y: 80, width: self.frame.width, height: self.frameHeight - 174)
        self.optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionsCell")
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        self.optionsTableView.alwaysBounceVertical = false
        self.optionsTableView.backgroundColor = UIColor.clear
        self.optionsTableView.alpha = 0.0
        self.optionsTableView.rowHeight = 40.0
        self.optionsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.addSubview(self.optionsTableView)
        
    }
    
    /* Table view functions */
    
    // Set the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchTableView {
            return self.searchedPlayers.count
        }
        else {
            return self.optionValues.count
        }
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell?
        
        if tableView == self.searchTableView {
        
            cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            // Player name.
            cell?.textLabel?.text = self.searchedPlayers[(indexPath as NSIndexPath).row]["Name"]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:14)
            // Flage image.
            cell!.imageView?.image = UIImage(named: String(searchedPlayers[(indexPath as NSIndexPath).row]["RegionCode"]!).uppercased())
        }
        else {
            
            cell = self.optionsTableView.dequeueReusableCell(withIdentifier: "optionsCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            cell?.textLabel?.text = self.optionValues[indexPath.row][0]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:18)
        }
        
        // Return the cell.
        cell?.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell!
    }
    
    // Set the row height for all tableViews to 40.0.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Called when a tableViewCell is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.searchTableView {
        
            // Select the correct PlayerId depending on which tableView the selected cell is in.
            let playerData: [String: String]
        
            // Dissmiss keyboard and open player view controller.
            self.searchField.resignFirstResponder()
            playerData = searchedPlayers[(indexPath as IndexPath).row]
        
        
            // Assign value to selectedPlayerData.
            self.selectedPlayerData = playerData
        
            self.viewController.selectedPlayerData = playerData
            var identifier: String!
        
            // Perform the segue to the player view.
            switch self.type {
            case .Home:
                identifier = "homePlayerSegue"
            case .Rankings:
                identifier = "rankingsPlayerSegue"
            case .Favourites:
                identifier = "favouritesPlayerSegue"
            }
            
            self.viewController.performSegue(withIdentifier: identifier, sender: self.viewController)
            
        }
        
        else {
            self.viewController.rankingType = self.optionValues[indexPath.row][1]
            toggleOptions()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Search bar functions */
    
    // Called whenever something changes in the text field, i.e. a character has been typed in/deleted.
    func textFieldDidChange(_ textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        
        // If the text hasn't been cleared, check if it matches any players.
        if string != "" {
            
            // Create the request in the background to prevent any delay.
            DispatchQueue.global(qos: .background).async {
                
                // Get the data.
                self.searchedPlayers = searchForPlayer(SearchString: string!)
                
                // Execute in the background to allow for the data to be received.
                DispatchQueue.main.async {
                    
                    // If there are no results from the search.
                    if self.searchedPlayers.count == 0 {
                        
                        self.noResults = true
                        
                        // Fade out the table view, and fade in the no results label.
                        UIView.animate(withDuration: 0.2, animations: {
                            self.searchTableView.alpha = 0.0
                            self.noResultsLabel.alpha = 1.0
                            }, completion: { (complete: Bool) in
                                self.searchTableView.reloadData()
                    })}
                    
                    // If there are results from the search.
                    else {
                        self.noResults = false
                        
                        // Bring back the table view and remove the no results label if needed.
                        if self.searchTableView.alpha == 0 {
                            UIView.animate(withDuration: 0.2, animations: {
                                self.searchTableView.alpha = 1.0
                                self.noResultsLabel.alpha = 0.0
                            })
                        }
                        // Reload the table view data.
                        UIView.transition(with: self.searchTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.searchTableView.reloadData()}, completion: nil)
                    }
                }
            }
        }
        // If the text is empty or been cleared give an empty array.
        else {
            self.noResults = false
            
            self.searchedPlayers = []
            
            // Reload the table view with an animation.
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.searchTableView.alpha = 0.0
                    self.noResultsLabel.alpha = 0.0
                    }, completion: { (complete: Bool) in
                        self.searchTableView.reloadData()
                })
            }
        }
    }
    
    // Search bar selected.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Show cancel button and search tableview, and remove menu tableview.
        UIView.animate(withDuration: 0.25, animations: {
            self.cancelButton.alpha = 1.0
            self.searchTableView.alpha = 1.0
            }, completion: { (complete: Bool) in
                //self.mainTableView.removeFromSuperview()
        })
    }
    
    // Cancel button pressed next to search bar.
    func searchCanceled(_ sender: UIButton!) {
        // Remove keyboard.
        self.searchField.resignFirstResponder()
        
        // Reset search bar text.
        self.searchField.text = ""
        
        // Refresh search tableview data.
        self.searchedPlayers = []
        let range = NSMakeRange(0, self.searchTableView.numberOfSections)
        let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
        self.searchTableView.reloadSections(sections, with: .automatic)
        
        // Remove cancel button and search tableview, and show menu tableview.
        UIView.animate(withDuration: 0.25, animations: {
            self.cancelButton.alpha = 0.0
            self.searchTableView.alpha = 0.0
            }, completion: { (complete: Bool) in
                //self.searchTableView.removeFromSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
