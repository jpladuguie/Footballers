//
//  homeView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts
import NVActivityIndicatorView
import SideMenu

// The main home View Controller.
class homeView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var blurEffectView: UIVisualEffectView!
    
    // Search field and cancel button.
    var searchField: UITextField = UITextField()
    var cancelButton: UIButton = UIButton()
    
    // Table views.
    var searchTableView: UITableView = UITableView()
    var mainTableView: UITableView = UITableView()
    
    // Data.
    var searchedPlayers: [[String: String]] = [[String: String]]()
    var topScorersData = [[String: String]]()
    var topAssistsData = [[String: String]]()
    var topPasserData = [[String: String]]()
    
    // Section titles.
    var sectionTitles: [String]!
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // The player id or ranking type needed for a segue when a player or ranking table is selected.
    var selectedPlayerData = [String: String]()
    var selectedRanking: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 174)
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.alpha = 0.0
        
        // Set the current page and title.
        currentPage = "Home"
        self.title = "Home"
        
        // Set up the View Controller.
        setUpView(viewController: self)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Create loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Get the data in the background, and once it has finished create all the subviews.
        DispatchQueue.global(qos: .background).async {
            
            // Get the data needed for the tableViews.
            self.topScorersData = getPlayerRankings(SortValue: "Goals", StartPosition: 0, EndPosition: 5)
            self.topAssistsData = getPlayerRankings(SortValue: "Assists", StartPosition: 0, EndPosition: 3)
            self.topPasserData = getPlayerRankings(SortValue: "PassSuccess", StartPosition: 0, EndPosition: 1)
            DispatchQueue.main.async {
                
                // If the data has been received, create all the subViews with the data.
                if self.topScorersData.isEmpty == false {
                    self.createSubViews()
                }
                // Otherwise, display the error message.
                else {
                    createErrorMessage(viewController: self, message: "Unable to connect to server.")
                    
                    // Fade out activity indicator.
                    UIView.animate(withDuration: 1.0, animations: {
                    self.activityIndicator.alpha = 0.0
                        }, completion: { (complete: Bool) in
                            self.activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    // Initiate all the subViews, and fade them in.
    func createSubViews() {
        
        // Create search bar.
        self.searchField.frame = CGRect(x: 10, y: 64, width: self.view.frame.width - 20, height: 50)
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
        self.searchField.alpha = 0.0
        
        // Create cancel button for search bar.
        self.cancelButton = UIButton(frame: CGRect(x: self.view.frame.width - 70, y: 64, width: 60, height: 50))
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.addTarget(self, action: #selector(searchCanceled), for: .touchUpInside)
        self.cancelButton.alpha = 0.0
        
        // Create the main table view.
        self.mainTableView = UITableView(frame: CGRect(x: 0, y: 114, width: self.view.frame.width, height: self.view.frame.height - 174))
        // Register the seperate cell classes.
        self.mainTableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.mainTableView.register(playerRatingCell.self, forCellReuseIdentifier: NSStringFromClass(playerRatingCell.self))
        self.mainTableView.register(titleCell.self, forCellReuseIdentifier: NSStringFromClass(titleCell.self))
        self.mainTableView.register(playerDividerCell.self, forCellReuseIdentifier: NSStringFromClass(playerDividerCell.self))
        // Set the delegate and data source.
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.mainTableView.backgroundColor = lightGrey
        // Set the alpha to zero so it can be faded in.
        self.mainTableView.alpha = 0
        
        
        // Create search tableview.
        self.searchTableView.frame = CGRect(x: 0, y: 114, width: self.view.frame.width, height: self.view.frame.height - 174)
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.alwaysBounceVertical = false
        self.searchTableView.backgroundColor = UIColor.clear
        self.searchTableView.alpha = 0.0
        self.searchTableView.rowHeight = 40.0
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Add views in correct order.
        self.view.addSubview(self.mainTableView)
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.searchTableView)
        self.view.addSubview(self.searchField)
        self.view.addSubview(self.cancelButton)
        
        
        // Fade items in.
        UIView.animate(withDuration: 1.0, animations: {
            self.mainTableView.alpha = 1.0
            self.searchField.alpha = 1.0
            self.activityIndicator.alpha = 0.0
            }, completion: { (complete: Bool) in
                self.activityIndicator.removeFromSuperview()
        })
    }
    
    // Set the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchTableView {
            return self.searchedPlayers.count
        }
        else {
            return 10
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
            
            if (indexPath as NSIndexPath).row == 0 {
                // Create a cell from the playerDividerCell class.
                let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
                title.titleLabel.text = "Top Scorers"
                
                // Set the main cell to the new one.
                cell = title
            }
            
            else if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
            
                // Create the custom cell using the rankingTableCell class..
                let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
                // Move the everything slightly to the left, as the ranking numbers will only
                // Be between 1 and 5, so space for only one digit is needed and not 3 which
                // Is the default.
                rankingCell.positionLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
                rankingCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
                rankingCell.nameLabel.frame = CGRect(x: 75, y: 0, width: 320, height: 40)
            
                // Assign the correct values to the tableView cell.
                rankingCell.positionLabel.text = String(indexPath.row)
                rankingCell.nameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Name"]
                rankingCell.statValueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Goals"]
                rankingCell.flagImage.image = UIImage(named: String((self.topScorersData[(indexPath as NSIndexPath).row - 1]["RegionCode"]?.uppercased())! + "")!)!
            
                // Set the cell.
                cell = rankingCell
            }
            
            else if (indexPath as NSIndexPath).row == 6 {
                // Create a cell from the playerDividerCell class.
                let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
                title.titleLabel.text = "Most Assists"
                
                // Set the main cell to the new one.
                cell = title
            }
                
            else {
                // Create a cell from the playerRatingCell class.
                let ratingCell: playerRatingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerRatingCell.self), for: indexPath) as! playerRatingCell
                
                ratingCell.selectionStyle = .gray
                
                // Set the values of the rating name and its value.
                ratingCell.ratingNameLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Name"]
                ratingCell.ratingValueLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Assists"]
                
                // Get the rating value as a float.
                let ratingValue: Float = Float(self.topAssistsData[(indexPath as NSIndexPath).row - 7]["Assists"]!)! / Float(self.topAssistsData[0]["Assists"]!)! * 100.0
                // Get the bar width depending on the value and the screen width.
                let barWidth: Int = Int(Float(ratingValue * Float(self.view.frame.width - 40)) / 100.0)
                // Create the bar as a UIView and set its colour depending on the strength of the rating.
                ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
                ratingCell.ratingBar.backgroundColor = getRatingColour(value: Int(ratingValue))
                
                // Animate the rating bar so that it slides in.
                UIView.animate(withDuration: 1.0, animations: {
                    ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
                })
                
                // Set the main cell to the new one.
                cell = ratingCell
            }
        }
        
        
        // Return the cell.
        cell?.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell!
    }
    
    // Set the row height for all tableViews to 40.0.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchTableView {
            return 40.0
        }
        else {
            if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 6{
                return 40.0
            }
            else if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
                return 40.0
            }
            else {
                return 50.0
            }
        }
    }
    
    // Called when a tableViewCell is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select the correct PlayerId depending on which tableView the selected cell is in.
        let playerData: [String: String]
        
        if tableView == self.searchTableView {
            // Dissmiss keyboard and open player view controller.
            self.searchField.resignFirstResponder()
            playerData = searchedPlayers[(indexPath as IndexPath).row]
        }
        else {
            if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
                self.mainTableView.deselectRow(at: indexPath, animated: true)
                playerData = self.topScorersData[(indexPath as NSIndexPath).row - 1]
            }
            else {
                self.mainTableView.deselectRow(at: indexPath, animated: true)
                playerData = self.topAssistsData[(indexPath as NSIndexPath).row - 6]
            }
        }
        
        // Assign value to selectedPlayerData.
        self.selectedPlayerData = playerData
        
        // Perform the segue to the player view.
        performSegue(withIdentifier: "homePlayerSegue", sender: self)
    }
    
    // Called when a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If a player has been selected, send the correct PlayerId to the playerView.
        if(segue.identifier == "homePlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
        }
        // If a ranking has been selected, send the correct type of ranking to rankingsView.
        else if (segue.identifier == "homeRankingSegue") {
            let rankingClass = (segue.destination as! rankingsView)
            rankingClass.rankingType = self.selectedRanking
        }
    }
    
    /* Search bar functions */
    
    // Search Text Field Edited
    func textFieldDidChange(_ textField: UITextField) {
        
        // Get text from text field, convert it to lower case and remove any special characters.
        let string = textField.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        
        // If the text hasn't been cleared check if it matches any players.
        if string != "" {
            
            DispatchQueue.global(qos: .background).async {
                
                self.searchedPlayers = searchForPlayer(SearchString: string!)
                
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
            //self.mainTableView.alpha = 0.0
            self.blurEffectView.alpha = 1.0
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
            //self.mainTableView.alpha = 1.0
            self.blurEffectView.alpha = 0.0
            }, completion: { (complete: Bool) in
                //self.searchTableView.removeFromSuperview()
            })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
