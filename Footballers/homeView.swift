//
//  homeView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import SwiftyJSON

class homeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var topScorersTable: UITableView!
    var topScorersData = [[String]]()
    var selectedPlayerId: String?

    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "homeMenuSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Stats table view.
        self.topScorersTable = UITableView(frame: CGRect(x: 0, y: 160, width: self.view.frame.width, height: 400))
        self.topScorersTable.delegate = self
        self.topScorersTable.dataSource = self
        self.topScorersTable.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.topScorersTable.separatorStyle = UITableViewCellSeparatorStyle.none
        self.topScorersTable.backgroundColor = UIColor.clear
        self.topScorersTable.alpha = 0.0
        self.view.addSubview(self.topScorersTable)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.topScorersTable.alpha = 1.0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Home"
        self.title = "Home"
        
        // Set background.
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Menu bar button
        let menuButton = UIButton(type: UIButtonType.custom) as UIButton
        menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        menuButton.setImage(UIImage(named: "menuButton.png"), for: UIControlState())
        menuButton.addTarget(self, action: #selector(homeView.menuOpened(_:)), for:.touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Navigation bar.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navBar = UIView()
        navBar.frame = CGRect(x: -1, y: 0, width: self.view.frame.width + 1, height: 64)
        navBar.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.view.addSubview(navBar)
        
        // Shadow effect.
        navBar.layer.shadowRadius = 1
        navBar.layer.shadowOpacity = 1
        navBar.layer.shadowColor = UIColor.black.cgColor
        navBar.layer.shadowOffset = CGSize.zero
        navBar.layer.shouldRasterize = true
        navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
        
        // Get data.
        var parameters = [
            "category" : "summary",
            "subcategory" : "all",
            "statsAccumulationType" : "0",
            "isCurrent" : "true",
            "playerId" : "",
            "teamIds" : "",
            "matchId" : "",
            "stageId" : "",
            "tournamentOptions" : "2,3,4,5,22",
            "sortBy": "goal",
            "sortAscending" : "false",
            "age" : "",
            "ageComparisonType" : "",
            "appearances" : "",
            "appearancesComparisonType" : "",
            "field" : "Overall",
            "nationality" : "",
            "positionOptions" : "",
            "timeOfTheGameEnd" : "",
            "timeOfTheGameStart" : "",
            "isMinApp" : "false",
            "page" : "",
            "includeZeroValues" : "",
            "numberOfPlayersToPick" : "50" ]
        
        // Get the data from the url, and create a JSON object to parse it. No modelLastMode is needed as
        // This is the first time the data is being called.
        let data = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "") as String
        var json : JSON!
        
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        //print(json)
        
        //for player in (json?["playerTableStats"])! {
        //    print(player[1]["name"])
        //}
        
        
        var i = 0
        while i < 50 {
            topScorersData.append([String(describing: json["playerTableStats"][i]["regionCode"]), String(describing: json["playerTableStats"][i]["name"]), String(describing: json["playerTableStats"][i]["goal"]), String(describing: json["playerTableStats"][i]["playerId"])])
            i += 1
        }
        
        print(topScorersData)
        
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50 
    }
    
    
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        /*var cell:UITableViewCell
        
        // Create cell.
        let statCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
        statCell.statNameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][1]
        statCell.statValueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][2]
        
        // Get the image from the player's url, and create an imageView for it. Try except needed in case player has no image.
        var image = UIImage(named: "defaultPlayerImage.png")
        
        // Check whether image is available.
        do {
            let imageData = try Data(contentsOf: URL(string: "https://d2zywfiolv4f83.cloudfront.net/img/players/" + self.topScorersData[(indexPath as NSIndexPath).row][3] + ".jpg")!, options: NSData.ReadingOptions())
            image = UIImage(data: imageData)
        } catch {
            print("No player image found.")
        }
        
        statCell.profileImage.image = image
        
        // Set cell.
        cell = statCell
        
        
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell*/
        
        var cell:UITableViewCell?
        
        cell = self.topScorersTable.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
        cell!.backgroundColor = UIColor.clear
        
        // Player name.
        cell?.textLabel?.text = self.topScorersData[(indexPath as NSIndexPath).row][1]
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont(name: (cell?.textLabel?.font?.fontName)!, size:14)
        // Flage image.
        cell!.imageView?.image = UIImage(named: String(self.topScorersData[(indexPath as NSIndexPath).row][0]).uppercased())
        
        return cell!
        
    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Player selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.topScorersTable.deselectRow(at: indexPath, animated: true)
        self.selectedPlayerId = self.topScorersData[(indexPath as NSIndexPath).row][3]
        performSegue(withIdentifier: "homePlayerSegue", sender: self)
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "homePlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData["playerId"] = self.selectedPlayerId
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
