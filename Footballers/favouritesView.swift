//
//  favouritesView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class favouritesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Player data array and tableView.
    var players = [[String]]()
    var playersTableView: UITableView!
    var isTableViewSetUp: Bool = false
    
    // Selected playerId for segue to playerView.
    var selectedPlayerData = [String: String]()
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "favouritesMenuSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.players = getPlayersFromFavourites()
        if self.players.count != 0 {
            if isTableViewSetUp == false {
                setUpTableView()
                isTableViewSetUp = true
            }
            else {
                self.playersTableView.reloadData()
            }
        }
        else {
            createErrorMessage(viewController: self, message: "No players in favourites")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Favourites"
        self.title = "Favourites"
        
        setUpView(viewController: self)
        
        self.players = getPlayersFromFavourites()
        
        if self.players.count != 0 {
            setUpTableView()
            isTableViewSetUp = true
        }
        else {
            createErrorMessage(viewController: self, message: "No players in favourites")
        }
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // Create cell.
        let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
        
        rankingCell.positionLabel.text = String(indexPath.row + 1)
        rankingCell.nameLabel.text = self.players[(indexPath as NSIndexPath).row][1]
        
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
        self.playersTableView.deselectRow(at: indexPath, animated: true)
        self.selectedPlayerData["PlayerId"] = self.players[(indexPath as NSIndexPath).row][0]
        self.selectedPlayerData["Name"] = self.players[(indexPath as NSIndexPath).row][1]
        self.selectedPlayerData["RegionCode"] = self.players[(indexPath as NSIndexPath).row][2]
        performSegue(withIdentifier: "favouritesPlayerSegue", sender: self)
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favouritesPlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
            
        }
    }
    
    func setUpTableView() {
        
        // Create player label.
        let playerLabel = UILabel(frame: CGRect(x: 95.0, y: Double((self.navigationController?.navigationBar.frame.height)! + 25.0), width: 100.0, height: 30.0))
        // Set the colour to white, add the text and add to view.
        playerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        playerLabel.text = "Player"
        playerLabel.textColor = UIColor.white
        playerLabel.alpha = 0.0
        self.view.addSubview(playerLabel)
        
        // Create table view.
        self.playersTableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100))
        self.playersTableView.delegate = self
        self.playersTableView.dataSource = self
        self.playersTableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.playersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.playersTableView.backgroundColor = lightGrey
        self.playersTableView.alpha = 0.0
        self.view.addSubview(self.playersTableView)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.playersTableView.alpha = 1.0
            playerLabel.alpha = 1.0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
