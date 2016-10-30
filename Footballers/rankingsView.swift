//
//  rankingsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class rankingsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Default values for page title and ranking type.
    var rankingType: String! = "goal"
    var rankingTitle: String! = "Top Scorers"
    
    // Player data array and tableView.
    var players = [[String]]()
    var statsTableView: UITableView!
    
    // Selected playerId for segue to playerView.
    var selectedPlayerData = [String: String]()
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "rankingsMenuSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the current page and title.
        currentPage = "Rankings"
        self.title = self.rankingTitle
        
        // Set up the View Controller.
        setUpView(viewController: self)
        
        DispatchQueue.global(qos: .background).async {
            // Get the data needed for the tableView.
            self.players = getPlayerRankings(type: self.rankingType, numberToGet: 100)
            DispatchQueue.main.async {
                
                // Create player label.
                let playerLabel = UILabel(frame: CGRect(x: 95.0, y: Double((self.navigationController?.navigationBar.frame.height)! + 25.0), width: 100.0, height: 30.0))
                // Set the colour to white, add the text and add to view.
                playerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                playerLabel.text = "Player"
                playerLabel.textColor = UIColor.white
                playerLabel.alpha = 0.0
                self.view.addSubview(playerLabel)
                
                
                // Create statistic label.
                let statlabel = UILabel(frame: CGRect(x: 200.0, y: Double((self.navigationController?.navigationBar.frame.height)! + 25.0), width: Double(self.view.frame.width - 220.0), height: 30.0))
                // Set the colour to white, add the text and add to view.
                statlabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                statlabel.text = "Goals"
                statlabel.textAlignment = .right
                statlabel.textColor = UIColor.white
                statlabel.alpha = 0.0
                self.view.addSubview(statlabel)
                
                // Create the tableView with the data,
                self.statsTableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100))
                self.statsTableView.delegate = self
                self.statsTableView.dataSource = self
                self.statsTableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
                self.statsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
                self.statsTableView.backgroundColor = lightGrey
                self.statsTableView.alpha = 0.0
                self.view.addSubview(self.statsTableView)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.statsTableView.alpha = 1.0
                    playerLabel.alpha = 1.0
                    statlabel.alpha = 1.0
                })
            }
        }
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // Create cell.
        let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
        rankingCell.rankingLabel.text = String(indexPath.row + 1)
        rankingCell.statNameLabel.text = self.players[(indexPath as NSIndexPath).row][1]
        rankingCell.statValueLabel.text = self.players[(indexPath as NSIndexPath).row][3]
        
        let image = UIImage(named: String(self.players[(indexPath as NSIndexPath).row][2].uppercased() + ""))
        
        rankingCell.flagImage.image = image
            
        // Set cell.
        cell = rankingCell
        return cell
    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Player selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.statsTableView.deselectRow(at: indexPath, animated: true)
        self.selectedPlayerData["playerId"] = self.players[(indexPath as NSIndexPath).row][0]
        self.selectedPlayerData["name"] = self.players[(indexPath as NSIndexPath).row][1]
        self.selectedPlayerData["regionCode"] = self.players[(indexPath as NSIndexPath).row][2]
        performSegue(withIdentifier: "rankingsPlayerSegue", sender: self)
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rankingsPlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
