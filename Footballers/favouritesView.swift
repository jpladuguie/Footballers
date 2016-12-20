//
//  favouritesView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class favouritesView: templateViewController, UITableViewDelegate, UITableViewDataSource {

    // Player data array and tableView.
    var players = [[String]]()
    var playersTableView: UITableView!
    var isTableViewSetUp: Bool = false
    
    /*override func viewDidAppear(_ animated: Bool) {
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
    }*/
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func viewDidLoad() {
        self.type = .Favourites
        
        super.viewDidLoad()
        
        currentView = .Favourites
        self.title = "Favourites"
        
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
        
        rankingCell.nameLabel.text = self.players[(indexPath as NSIndexPath).row][1]
        rankingCell.teamLabel.text = self.players[(indexPath as NSIndexPath).row][3]
        
        let image = UIImage(named: String(self.players[(indexPath as NSIndexPath).row][2].uppercased() + ""))
        
        rankingCell.flagImage.image = image
        
        DispatchQueue.main.async {
        
        var playerImage: UIImage!
        
        do {
            let imageData = try Data(contentsOf: URL(string: self.players[(indexPath as NSIndexPath).row][4])!, options: NSData.ReadingOptions())
            playerImage = UIImage(data: imageData)
        } catch {
            // If the image cannot be fetched from the API, set it to the default one.
            playerImage = UIImage(named: "defaultPlayerImage.png")
            print("No player image found for " + self.players[(indexPath as NSIndexPath).row][1] + ".")
        }

        
        rankingCell.profilePhoto.image = playerImage
        }
        
        // Set cell.
        cell = rankingCell
        return cell
    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
        
        // Create table view.
        self.playersTableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 124))
        self.playersTableView.delegate = self
        self.playersTableView.dataSource = self
        self.playersTableView.register(imageRankingCell.self, forCellReuseIdentifier: NSStringFromClass(imageRankingCell.self))
        self.playersTableView.backgroundColor = lightGrey
        self.playersTableView.alpha = 0.0
        
        //self.view.addSubview(playerLabel)
        self.view.addSubview(self.playersTableView)
        self.view.bringSubview(toFront: self.navBar)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.playersTableView.alpha = 1.0
            //playerLabel.alpha = 1.0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
