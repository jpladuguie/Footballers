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
        self.searchField.frame = CGRect(x: 10, y: 25, width: 170, height: 40)
        self.searchField.autocorrectionType = UITextAutocorrectionType.no
        self.searchField.attributedPlaceholder = NSAttributedString(string:"Search for players...",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        self.searchField.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.searchField.keyboardType = UIKeyboardType.default
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.searchField.font = UIFont.systemFont(ofSize: 15)
        self.searchField.textColor = UIColor.white
        self.searchField.returnKeyType = UIReturnKeyType.done
        self.searchField.addTarget(self, action: #selector(sideMenuView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.searchField.delegate = self
        self.searchField.tintColor = UIColor.white
        
        // Add search icon to search bar.
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        searchIcon.frame = CGRect(x: 7.5, y: 12.5, width: 15, height: 15)
        self.searchField.addSubview(searchIcon)
        let searchBox = UIView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 40))
        self.searchField.leftView = searchBox;
        self.searchField.leftViewMode = UITextFieldViewMode.always
        
        self.view.addSubview(self.searchField)
        
        // Create cancel button for search bar.
        self.cancelButton = UIButton(frame: CGRect(x: 180, y: 25, width: 60, height: 40))
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.addTarget(self, action: #selector(searchCanceled), for: .touchUpInside)
        self.cancelButton.alpha = 0.0
        self.view.addSubview(self.cancelButton)
        
        // Create divider between search bar and tableview.
        /*let dividerImage = UIImage(named: "whiteLine.png")
        let divider = UIImageView(image: dividerImage!)
        divider.frame = CGRect(x: 10, y: 63, width: 220, height: 1)
        view.addSubview(divider)*/
        
        // Create menu tableview.
        self.menuTableView.frame = CGRect(x: 0, y: 100, width: 240, height: 400)
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.alwaysBounceVertical = false
        self.menuTableView.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.menuTableView.rowHeight = 50.0
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(self.menuTableView)
        
        // Create search tableview.
        self.searchTableView.frame = CGRect(x: 0, y: 80, width: 240, height: 400)
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.searchTableView.alpha = 0.0
        self.searchTableView.rowHeight = 40.0
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(self.searchTableView)
        
        // Get player data from file.
        let path = Bundle.main.path(forResource: "playerData", ofType: "txt")
        let text = try? NSString(contentsOfFile: path! as String, encoding: String.Encoding.utf8.rawValue)
        if let dataFromString = text!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
            self.json = JSON(data: dataFromString)
        }
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.menuTableView {
            
            cell = self.menuTableView.dequeueReusableCell(withIdentifier: "menuCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            // Create a menu label and add it to cell.
            let menuItem : UILabel = UILabel()
            menuItem.frame = CGRect(x: 85, y: 0, width: 100, height: 50)
            menuItem.text = self.menuItems[(indexPath as NSIndexPath).row]
            menuItem.textColor = UIColor.white
            if self.menuItems[(indexPath as NSIndexPath).row] == currentPage {
                // Selected page.
                menuItem.font = UIFont.boldSystemFont(ofSize: 20.0)
            }
            cell!.contentView.addSubview(menuItem)
  
            // Create menu icon, centre it and add it to cell.
            let menuIcon : UIImageView = UIImageView(frame: CGRect(x: (80 - self.menuIconSizes[(indexPath as NSIndexPath).row][0])/2, y: (50 - self.menuIconSizes[(indexPath as NSIndexPath).row][1])/2, width: self.menuIconSizes[(indexPath as NSIndexPath).row][0], height: self.menuIconSizes[(indexPath as NSIndexPath).row][1]))
            menuIcon.image = UIImage(named: self.menuIcons[(indexPath as NSIndexPath).row])
            cell!.contentView.addSubview(menuIcon)
            
        }
        
        if tableView == self.searchTableView {
            
            cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
            cell!.backgroundColor = UIColor.clear
            
            // Player name.
            cell?.textLabel?.text = self.searchedPlayers[(indexPath as NSIndexPath).row]["name"]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:14)
            // Flage image.
            cell!.imageView?.image = UIImage(named: String(searchedPlayers[(indexPath as NSIndexPath).row]["regionCode"]!).uppercased())

        }
        
        return cell!
    }
    
    // When tableview item is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.menuTableView {
            // Segue to page.
            performSegue(withIdentifier: self.menuItems[(indexPath as NSIndexPath).row].lowercased() + "Segue", sender: self)
        }
        
        if tableView == self.searchTableView {
            
            // Dissmiss keyboard and open player view controller.
            self.searchField.resignFirstResponder()
            self.playerData = self.searchedPlayers[(indexPath as NSIndexPath).row]
            performSegue(withIdentifier: "playerSegue", sender: self)
            
        }
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "playerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.playerData
            
        }
    }
    
    // Search Text Field Edited
    func textFieldDidChange(_ textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        
        // If the text hasn't been cleared check if it matches any players.
        if string != "" {
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                
                var counter: Int = 0
                self.searchedPlayers = []
                
                mainLoop: for (_, player) in self.json!["players"] {
                    if string?.range(of: " ") == nil {
                        let nameArray = String(describing: player["name"]).lowercased().folding(options: .diacriticInsensitive, locale: nil).components(separatedBy: " ")
                        subLoop: for name in nameArray {
                            if name.hasPrefix(string!) {
                                
                                var tempPlayer = [String: String]()
                                
                                for (name, item) in player {
                                    tempPlayer[name] = String(describing: item)
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
                        let name = String(describing: player["name"]).lowercased().folding(options: .diacriticInsensitive, locale: nil)
                        if name.range(of: string!) != nil {

                            var tempPlayer = [String: String]()
                            
                            for (name, item) in player {
                                tempPlayer[name] = String(describing: item)
                            }
                            
                            self.searchedPlayers.append(tempPlayer)
                            
                            counter += 1
                            
                            if counter == 6 {
                                break mainLoop
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    let range = NSMakeRange(0, self.searchTableView.numberOfSections)
                    let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
                    self.searchTableView.reloadSections(sections, with: .automatic)
                })
            })
        }
            // If the text is empty or been cleared give an empty array.
        else {
            self.searchedPlayers = []
            let range = NSMakeRange(0, self.searchTableView.numberOfSections)
            let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
            self.searchTableView.reloadSections(sections, with: .automatic)
        }
    }
    
    // Search bar selected.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Show cancel button and search tableview, and remove menu tableview.
        UIView.animate(withDuration: 0.25, animations: {
            self.cancelButton.alpha = 1.0
            self.searchTableView.alpha = 1.0
            self.menuTableView.alpha = 0.0
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
            self.menuTableView.alpha = 1.0
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
