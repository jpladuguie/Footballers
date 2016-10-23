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
    
    var statsTableView: UITableView!
    
    var rankingType: String!
    var rankingTitle: String!
    
    var players = [[String]]()
    var selectedPlayerId: String?
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!

    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "rankingsMenuSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.players = getPlayerRankings(type: "goal", numberToGet: "100")
        
        self.statsTableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)!))
        self.statsTableView.delegate = self
        self.statsTableView.dataSource = self
        self.statsTableView.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.statsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.statsTableView.backgroundColor = lightGrey
        self.statsTableView.alpha = 0.0
        self.view.addSubview(self.statsTableView)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.statsTableView.alpha = 1.0
        }, completion: { (complete: Bool) in
                self.activityIndicator.removeFromSuperview()
                return
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Rankings"
        self.title = "Top Scorers"
        
        setUpView(viewController: self)
        
        // Loading activity indicator.
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width/2 - 25), y: (self.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white)
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
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
        rankingCell.flagImage.image = try UIImage(named: String(self.players[(indexPath as NSIndexPath).row][2].uppercased() + ""))!
            
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
        self.selectedPlayerId = self.players[(indexPath as NSIndexPath).row][0]
        performSegue(withIdentifier: "rankingsPlayerSegue", sender: self)
    }
    
    // Select a player
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rankingsPlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData["playerId"] = self.selectedPlayerId
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
