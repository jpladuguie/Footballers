//
//  navigationBar.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 17/12/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class navigationBar: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Boolean which is true when the view is extended down, and false otherwise.
    var viewExtended: Bool! = false
    
    // Float which stores the height of the screen, to handle screens of different sizes.
    // Passed from the view controller which instantiates the class.
    var frameHeight: CGFloat!
    
    // Search field and cancel button.
    var searchField: UITextField = UITextField()
    var cancelButton: UIButton = UIButton()
    
    // Table view.
    var searchTableView: UITableView = UITableView()
    
    // Player data.
    var searchedPlayers: [[String: String]] = [[String: String]]()
    
    // The PlayerId needed for a segue when a player is selected.
    var selectedPlayerData = [String: String]()
    
    // Divider line.
    var divider: UIImageView = UIImageView()
    
    var viewController: homeView!
    
    
    // Called when the view initiates.
    override init (frame : CGRect) {
        
        // Initiate the class.
        super.init(frame : CGRect(x: -1, y: 0, width: frame.width + 1, height: 64))
        
        // Set the screen height.
        self.frameHeight = frame.height
        
        // Set the default background colour.
        self.backgroundColor = darkGrey
        
        // Create the search bar, cancel button and search table view.
        createSearchBar()
        
    }
    
    // Called when the search icon is pressed.
    func searchPressed() {
        
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
            self.searchTableView.alpha = alpha
            self.divider.alpha = alpha
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
    
    func createSearchBar() {
        
        // Create search bar.
        self.searchField.frame = CGRect(x: 20, y: 60, width: self.frame.width - 40, height: 50)
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
        self.searchField.alpha = 0.0
        
        // Create cancel button for search bar.
        self.cancelButton = UIButton(frame: CGRect(x: self.frame.width - 70, y: 64, width: 60, height: 50))
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.alpha = 0.0
        
        // Create the divider.
        self.divider.image = UIImage(named: "whiteLine.png")
        self.divider.frame = CGRect(x: 20.0, y: 110.0, width: self.frame.width - 40, height: 1.0)
        self.divider.alpha = 0.0
        
        // Create search tableview.
        self.searchTableView.frame = CGRect(x: 5, y: 120, width: self.frame.width - 20, height: self.frameHeight - 174)
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
        
    }
    
    /* Table view functions */
    
    // Set the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedPlayers.count
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell?
            
        cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
        cell!.backgroundColor = UIColor.clear
            
        // Player name.
        cell?.textLabel?.text = self.searchedPlayers[(indexPath as NSIndexPath).row]["Name"]
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:14)
        // Flage image.
        cell!.imageView?.image = UIImage(named: String(searchedPlayers[(indexPath as NSIndexPath).row]["RegionCode"]!).uppercased())
            
        
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
        // Select the correct PlayerId depending on which tableView the selected cell is in.
        let playerData: [String: String]
        
        // Dissmiss keyboard and open player view controller.
        self.searchField.resignFirstResponder()
        playerData = searchedPlayers[(indexPath as IndexPath).row]
        
        
        // Assign value to selectedPlayerData.
        self.selectedPlayerData = playerData
        
        self.viewController.selectedPlayerData = playerData
        
        // Perform the segue to the player view.
        self.viewController.performSegue(withIdentifier: "homePlayerSegue", sender: self.viewController)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Search bar functions */
    
    // Search Text Field Edited
    func textFieldDidChange(_ textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        
        // If the text hasn't been cleared, check if it matches any players.
        if string != "" {
            // Create the request in the background to prevent any delay.
            DispatchQueue.global(qos: .background).async {
                
                // Get the data.
                self.searchedPlayers = searchForPlayer(SearchString: string!)
                
                // Reload the table view with an animation.
                DispatchQueue.main.async {
                    UIView.transition(with: self.searchTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.searchTableView.reloadData()}, completion: nil)
                }
                
            }
        }
            // If the text is empty or been cleared give an empty array.
        else {
            self.searchedPlayers = []
            
            // Reload the table view with an animation.
            DispatchQueue.main.async {
                UIView.transition(with: self.searchTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.searchTableView.reloadData()}, completion: nil)
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
