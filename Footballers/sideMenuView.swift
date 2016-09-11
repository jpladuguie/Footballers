//
//  sideMenuView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import SwiftyJSON

class sideMenuView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Tableviews.
    var searchTableView: UITableView = UITableView()
    var menuTableView: UITableView = UITableView()
    
    // Search field and cancel button.
    var searchField: UITextField = UITextField()
    var cancelButton: UIButton = UIButton()
    
    // Menu items and icons.
    var menuItems: [String] = [String]()
    var menuIcons: [String] = [String]()
    var menuIconSizes: [[CGFloat]] = [[CGFloat]]()
    
    // Players list.
    var searchedPlayers: [[String: String]] = [[String: String]]()
    var playerId: String = String()
    var playerName: String = String()
    var playerData: [String: String] = [String: String]()
    
    // Json data from text file.
    var json : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set grey background.
        self.view.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        
        // Set the menu items, the names of the images of the corresponding icons, and their sizes.
        self.menuItems = ["Home", "Teams", "Rankings", "Compare", "Favourites"]
        self.menuIcons = ["home.png", "team.png", "rankings.png", "compare.png", "favouriteButtonEmpty.png"]
        self.menuIconSizes = [[32, 32], [26, 32], [32, 18], [31, 32], [32, 32]]
        
        // Create search bar.
        self.searchField.frame = CGRectMake(10, 25, 170, 40)
        self.searchField.autocorrectionType = UITextAutocorrectionType.No
        self.searchField.attributedPlaceholder = NSAttributedString(string:"Search for players...",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.searchField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        self.searchField.keyboardType = UIKeyboardType.Default
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.searchField.font = UIFont.systemFontOfSize(15)
        self.searchField.textColor = UIColor.whiteColor()
        self.searchField.returnKeyType = UIReturnKeyType.Done
        self.searchField.addTarget(self, action: #selector(sideMenuView.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.searchField.delegate = self
        self.searchField.tintColor = UIColor.whiteColor()
        
        // Add search icon to search bar.
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        searchIcon.frame = CGRect(x: 7.5, y: 12.5, width: 15, height: 15)
        self.searchField.addSubview(searchIcon)
        let searchBox = UIView.init(frame: CGRectMake(10, 0, 30, 40))
        self.searchField.leftView = searchBox;
        self.searchField.leftViewMode = UITextFieldViewMode.Always
        
        self.view.addSubview(self.searchField)
        
        // Create cancel button for search bar.
        self.cancelButton = UIButton(frame: CGRect(x: 180, y: 25, width: 60, height: 40))
        self.cancelButton.titleLabel!.font = UIFont.systemFontOfSize(15)
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.addTarget(self, action: #selector(searchCanceled), forControlEvents: .TouchUpInside)
        self.cancelButton.alpha = 0.0
        self.view.addSubview(self.cancelButton)
        
        // Create divider between search bar and tableview.
        /*let dividerImage = UIImage(named: "whiteLine.png")
        let divider = UIImageView(image: dividerImage!)
        divider.frame = CGRect(x: 10, y: 63, width: 220, height: 1)
        view.addSubview(divider)*/
        
        // Create menu tableview.
        self.menuTableView.frame = CGRectMake(0, 100, 240, 400)
        self.menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.alwaysBounceVertical = false
        self.menuTableView.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.menuTableView.rowHeight = 50.0
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(self.menuTableView)
        
        // Create search tableview.
        self.searchTableView.frame = CGRectMake(0, 80, 240, 400)
        self.searchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.searchTableView.alpha = 0.0
        self.searchTableView.rowHeight = 40.0
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(self.searchTableView)
        
        // Get player data from file.
        let path = NSBundle.mainBundle().pathForResource("playerData", ofType: "txt")
        let text = try? NSString(contentsOfFile: path! as String, encoding: NSUTF8StringEncoding)
        if let dataFromString = text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            self.json = JSON(data: dataFromString)
        }
    }
    
    // Number of rows in tableview.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.menuTableView {
            count = self.menuItems.count
        }
        if tableView == self.searchTableView {
            count = self.searchedPlayers.count
        }
        
        return count!
    }
    
    // Set up tableview cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.menuTableView {
            
            cell = self.menuTableView.dequeueReusableCellWithIdentifier("menuCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clearColor()
            
            // Create a menu label and add it to cell.
            let menuItem : UILabel = UILabel()
            menuItem.frame = CGRectMake(85, 0, 100, 50)
            menuItem.text = self.menuItems[indexPath.row]
            menuItem.textColor = UIColor.whiteColor()
            if self.menuItems[indexPath.row] == currentPage {
                // Selected page.
                menuItem.font = UIFont.boldSystemFontOfSize(20.0)
            }
            cell!.contentView.addSubview(menuItem)
  
            // Create menu icon, centre it and add it to cell.
            let menuIcon : UIImageView = UIImageView(frame: CGRectMake((80 - self.menuIconSizes[indexPath.row][0])/2, (50 - self.menuIconSizes[indexPath.row][1])/2, self.menuIconSizes[indexPath.row][0], self.menuIconSizes[indexPath.row][1]))
            menuIcon.image = UIImage(named: self.menuIcons[indexPath.row])
            cell!.contentView.addSubview(menuIcon)
            
        }
        
        if tableView == self.searchTableView {
            
            cell = self.searchTableView.dequeueReusableCellWithIdentifier("searchCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clearColor()
            
            // Player name.
            cell?.textLabel?.text = self.searchedPlayers[indexPath.row]["name"]
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:14)
            // Flage image.
            cell!.imageView?.image = UIImage(named: String(searchedPlayers[indexPath.row]["regionCode"]!).uppercaseString)

        }
        
        return cell!
    }
    
    // When tableview item is selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.menuTableView {
            // Segue to page.
            performSegueWithIdentifier(self.menuItems[indexPath.row].lowercaseString + "Segue", sender: self)
        }
        
        if tableView == self.searchTableView {
            
            // Dissmiss keyboard and open player view controller.
            self.searchField.resignFirstResponder()
            self.playerData = self.searchedPlayers[indexPath.row]
            performSegueWithIdentifier("playerSegue", sender: self)
            
        }
    }
    
    // Select a player
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "playerSegue") {
            let playerClass = (segue.destinationViewController as! playerView)
            playerClass.playerData = self.playerData
            
        }
    }
    
    // Search Text Field Edited
    func textFieldDidChange(textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: nil)
        
        // If the text hasn't been cleared check if it matches any players.
        if string != "" {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var counter: Int = 0
                self.searchedPlayers = []
                
                mainLoop: for (_, player) in self.json!["players"] {
                    if string?.rangeOfString(" ") == nil {
                        let nameArray = String(player["name"]).lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: nil).componentsSeparatedByString(" ")
                        subLoop: for name in nameArray {
                            if name.hasPrefix(string!) {
                                
                                var tempPlayer = [String: String]()
                                
                                for (name, item) in player {
                                    tempPlayer[name] = String(item)
                                }
                                
                                self.searchedPlayers.append(tempPlayer)
                                
                                counter += 1
                        
                                if counter == 6 {
                                    break mainLoop
                                }
                                
                                break subLoop
                            }
                        }
                    }
                    else {
                        let name = String(player["name"]).lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: nil)
                        if name.rangeOfString(string!) != nil {

                            var tempPlayer = [String: String]()
                            
                            for (name, item) in player {
                                tempPlayer[name] = String(item)
                            }
                            
                            self.searchedPlayers.append(tempPlayer)
                            
                            counter += 1
                            
                            if counter == 6 {
                                break mainLoop
                            }
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let range = NSMakeRange(0, self.searchTableView.numberOfSections)
                    let sections = NSIndexSet(indexesInRange: range)
                    self.searchTableView.reloadSections(sections, withRowAnimation: .Automatic)
                })
            })
        }
            // If the text is empty or been cleared give an empty array.
        else {
            self.searchedPlayers = []
            let range = NSMakeRange(0, self.searchTableView.numberOfSections)
            let sections = NSIndexSet(indexesInRange: range)
            self.searchTableView.reloadSections(sections, withRowAnimation: .Automatic)
        }
    }
    
    // Search bar selected.
    func textFieldDidBeginEditing(textField: UITextField) {
        // Show cancel button and search tableview, and remove menu tableview.
        UIView.animateWithDuration(0.25, animations: {
            self.cancelButton.alpha = 1.0
            self.searchTableView.alpha = 1.0
            self.menuTableView.alpha = 0.0
        })
    }
    
    // Cancel button pressed next to search bar.
    func searchCanceled(sender: UIButton!) {
        // Remove keyboard.
        self.searchField.resignFirstResponder()
        
        // Reset search bar text.
        self.searchField.text = ""
        
        // Refresh search tableview data.
        self.searchedPlayers = []
        let range = NSMakeRange(0, self.searchTableView.numberOfSections)
        let sections = NSIndexSet(indexesInRange: range)
        self.searchTableView.reloadSections(sections, withRowAnimation: .Automatic)
        
        // Remove cancel button and search tableview, and show menu tableview.
        UIView.animateWithDuration(0.25, animations: {
            self.cancelButton.alpha = 0.0
            self.searchTableView.alpha = 0.0
            self.menuTableView.alpha = 1.0
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
