//
//  sideMenuView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

// View Controller for the side menu. It contains the search bar and 'cancel' button, as well as
// Two table views; one to show the various pages, such as 'Home' and 'Rankings', and one to show
// Results when searching for players.
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
        self.view.backgroundColor = darkGrey
        
        // Set the menu items, the names of the images of the corresponding icons, and their sizes.
        self.menuItems = ["Home", "Teams", "Rankings", "Compare", "Favourites"]
        self.menuIcons = ["home.png", "team.png", "rankings.png", "compare.png", "favouriteButtonEmpty.png"]
        self.menuIconSizes = [[32, 32], [26, 32], [32, 18], [31, 32], [32, 32]]
        
        // Create search bar.
        self.searchField.frame = CGRect(x: 10, y: 25, width: 210, height: 40)
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
        self.cancelButton = UIButton(frame: CGRect(x: 220, y: 25, width: 60, height: 40))
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.addTarget(self, action: #selector(searchCanceled), for: .touchUpInside)
        self.cancelButton.alpha = 0.0
        self.view.addSubview(self.cancelButton)
        
        // Create menu tableview.
        self.menuTableView.frame = CGRect(x: 0, y: 100, width: 280, height: 400)
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.alwaysBounceVertical = false
        self.menuTableView.backgroundColor = darkGrey
        self.menuTableView.rowHeight = 50.0
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(self.menuTableView)
        
        // Create search tableview.
        self.searchTableView.frame = CGRect(x: 0, y: 80, width: 280, height: 400)
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = darkGrey
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
        print(string)
        
        // If the text hasn't been cleared check if it matches any players.
        if string != "" {
            
            DispatchQueue.global(qos: .background).async {
                
                var counter: Int = 0
                self.searchedPlayers = []
                
                // Set up data container.
                let container = NSPersistentContainer(name: "playerDataModel")
                container.loadPersistentStores { storeDescription, error in
                    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    if let error = error {
                        print("Unable to load playerDataModel. Error: \(error)")
                    }
                }
                
                // Create a fetch request.
                var players = [PlayerData]()
                let request = PlayerData.createFetchRequest()
                // Set the predicate to look for players with a matching playerId.
                let predicate = "name BEGINSWITH[cd] '" + string! + "' OR name CONTAINS[cd] ' " + string! + "'"
                request.predicate = NSPredicate(format: predicate)
                
                // Get all players with matching id.g
                do {
                    players = try container.viewContext.fetch(request)
                    // If there are no matches, return false, else return true.
                } catch {
                    print("Unable to access playerFavouritesDataModel.")
                }
                
                for i in 0..<players.count {
                    self.searchedPlayers.append(["playerId" :  players[i].playerId!, "name" : players[i].name!, "regionCode" : players[i].regionCode!])
                    if i == 4 {
                        break
                    }
                }
                
                DispatchQueue.main.async {
                    let range = NSMakeRange(0, self.searchTableView.numberOfSections)
                    let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
                    self.searchTableView.reloadSections(sections, with: .automatic)
                }
            }
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
