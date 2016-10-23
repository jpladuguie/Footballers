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

class homeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var goalsAndAssistsTitle: UILabel!
    var goalsAndAssistsDivider: UIImageView!
    
    var topScorersButton: UIButton!
    var topScorersTable: UITableView!
    var topScorersData = [[String]]()
    
    var topAssistsButton: UIButton!
    var topAssistsTable: UITableView!
    var topAssistsData = [[String]]()
    
    var passingTitle: UIButton!
    var passingDivider: UIImageView!
    var topPasserData = [[String]]()
    var topPassingPlayerTitle: UIButton!
    
    var selectedPlayerId: String?
    var scrollView: UIScrollView!
    var mainView: UIView!
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var AssistsChartView: HorizontalBarChartView!
    
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "homeMenuSegue", sender: nil)
    }
    
    @IBAction func topScorersPressed(sender: UIButton) {
        print("Top Scorers")
    }
    
    @IBAction func topAssistsPressed(sender: UIButton) {
        print("Most Assists")
    }
    
    @IBAction func passingPressed(sender: UIButton) {
        print("Passing")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Goals and Assists Title
        self.goalsAndAssistsTitle = UILabel(frame: CGRect(x: 20, y: 110, width: self.view.frame.width - 40, height: 30))
        self.goalsAndAssistsTitle?.tintColor = UIColor.white
        self.goalsAndAssistsTitle?.font = UIFont.systemFont(ofSize: 28.0)
        self.goalsAndAssistsTitle?.text = "Goals and Assists"
        self.goalsAndAssistsTitle?.textColor = UIColor.white
        self.goalsAndAssistsTitle.alpha = 0.0
        self.mainView.addSubview(self.goalsAndAssistsTitle!)
        
        // Divider
        self.goalsAndAssistsDivider = UIImageView(image: UIImage(named: "whiteLine.png"))
        self.goalsAndAssistsDivider.frame = CGRect(x: 20, y: 150, width: self.view.frame.width - 40, height: 1)
        self.goalsAndAssistsDivider.alpha = 0.0
        self.mainView.addSubview(self.goalsAndAssistsDivider)
        
        // Top scorers button
        self.topScorersButton = UIButton(frame: CGRect(x: 20, y: 165, width: self.view.frame.width - 40, height: 30))
        self.topScorersButton?.tintColor = UIColor.white
        self.topScorersButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.topScorersButton?.setTitle("Top Scorers", for: .normal)
        self.topScorersButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.topScorersButton?.addTarget(self, action: #selector(topScorersPressed), for: .touchUpInside)
        self.topScorersButton.alpha = 0.0
        self.mainView.addSubview(self.topScorersButton!)
        
        // Top scorers table view.
        self.topScorersTable = UITableView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 200))
        self.topScorersTable.delegate = self
        self.topScorersTable.dataSource = self
        self.topScorersTable.register(rankingTableCell.self, forCellReuseIdentifier: NSStringFromClass(rankingTableCell.self))
        self.topScorersTable.separatorStyle = UITableViewCellSeparatorStyle.none
        self.topScorersTable.backgroundColor = UIColor.clear
        self.topScorersTable.isScrollEnabled = false
        self.topScorersTable.alpha = 0.0
        self.mainView.addSubview(self.topScorersTable)
        
        // Top assists button
        self.topAssistsButton = UIButton(frame: CGRect(x: 20, y: 415, width: self.view.frame.width - 40, height: 30))
        self.topAssistsButton?.tintColor = UIColor.white
        self.topAssistsButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.topAssistsButton?.setTitle("Most Assists", for: .normal)
        self.topAssistsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.topAssistsButton?.addTarget(self, action: #selector(topAssistsPressed), for: .touchUpInside)
        self.topAssistsButton.alpha = 0.0
        self.mainView.addSubview(self.topAssistsButton!)
        
        // Assists bar chart
        AssistsChartView.frame = CGRect(x: 12, y: 450, width: self.view.frame.width + 30, height: 140)
        AssistsChartView = configureHorizontalBarChart(barChart: AssistsChartView, values: [self.topAssistsData[0][2], self.topAssistsData[1][2], self.topAssistsData[2][2]] )
        self.mainView.addSubview(AssistsChartView)
        
        // Assists table view.
        self.topAssistsTable = UITableView(frame: CGRect(x: 40, y: 460, width: self.view.frame.width, height: 140))
        self.topAssistsTable.delegate = self
        self.topAssistsTable.dataSource = self
        self.topAssistsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.topAssistsTable.separatorStyle = UITableViewCellSeparatorStyle.none
        self.topAssistsTable.backgroundColor = UIColor.clear
        self.topAssistsTable.isScrollEnabled = false
        self.topAssistsTable.alpha = 0.0
        self.mainView.addSubview(self.topAssistsTable)
        
        // Passing stats title
        self.passingTitle = UIButton(frame: CGRect(x: 20, y: 600, width: self.view.frame.width - 40, height: 30))
        self.passingTitle?.tintColor = UIColor.white
        self.passingTitle?.titleLabel?.font = UIFont.systemFont(ofSize: 28.0)
        self.passingTitle?.setTitle("Passing", for: .normal)
        self.passingTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.passingTitle?.addTarget(self, action: #selector(topScorersPressed), for: .touchUpInside)
        self.passingTitle.alpha = 0.0
        self.mainView.addSubview(self.passingTitle!)
        
        // Passing divider
        self.passingDivider = UIImageView(image: UIImage(named: "whiteLine.png"))
        self.passingDivider.frame = CGRect(x: 20, y: 640, width: self.view.frame.width - 40, height: 1)
        self.passingDivider.alpha = 0.0
        self.mainView.addSubview(self.passingDivider)
        
        // Passing pie chart
        pieChartView.frame = CGRect(x: self.view.frame.width - 160, y: 650, width: 140 , height: 140)
        pieChartView = configurePieChart(pieChart: pieChartView, chartValue: Double(self.topPasserData[0][2])!)
        self.mainView.addSubview(pieChartView)
        
        self.topPassingPlayerTitle = UIButton(frame: CGRect(x: 20, y: 650, width: self.view.frame.width - 160, height: 30))
        self.topPassingPlayerTitle.tintColor = UIColor.white
        self.topPassingPlayerTitle.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.topPassingPlayerTitle.setTitle(self.topPasserData[0][1], for: .normal)
        self.topPassingPlayerTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.topPassingPlayerTitle.addTarget(self, action: #selector(topScorersPressed), for: .touchUpInside)
        self.topPassingPlayerTitle.alpha = 0.0
        self.mainView.addSubview(self.topPassingPlayerTitle)
        
        
        
        UIView.animate(withDuration: 1.0, animations: {
            self.goalsAndAssistsTitle.alpha = 1.0
            self.goalsAndAssistsDivider.alpha = 1.0
            
            self.topScorersButton.alpha = 1.0
            self.topScorersTable.alpha = 1.0
            
            self.topAssistsButton.alpha = 1.0
            
            self.passingTitle.alpha = 1.0
            self.passingDivider.alpha = 1.0
            self.topPassingPlayerTitle.alpha = 1.0
            }, completion: { (complete: Bool) in
                print("done")
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.topAssistsTable.alpha = 1.0
                    })
                
                return
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = "Home"
        self.title = "Home"
        
        // Set up views.
        self.mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2000))
        
        // Scroll view needed to fit content on screen.
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        self.scrollView.contentSize = self.mainView.bounds.size
        self.scrollView.addSubview(self.mainView)
        view.addSubview(self.scrollView)
        
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
        
        self.topScorersData = getPlayerRankings(type: "goal", numberToGet: "5")
        self.topAssistsData = getPlayerRankings(type: "assistTotal", numberToGet: "3")
        self.topPasserData = getPlayerRankings(type: "passSuccess", numberToGet: "1")
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cells = 0
        if tableView == self.topScorersTable {
            cells = 5
        }
        else {
            cells = 3
        }
        
        return cells
    }
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        if tableView == self.topScorersTable {
        
            // Create cell.
            let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
            rankingCell.rankingLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
            rankingCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
            rankingCell.statNameLabel.frame = CGRect(x: 75, y: 0, width: 320, height: 40)
            
            rankingCell.rankingLabel.text = String(indexPath.row + 1)
            rankingCell.statNameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][1]
            rankingCell.statValueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][2]
            rankingCell.flagImage.image = UIImage(named: String(self.topScorersData[(indexPath as NSIndexPath).row][0].uppercased() + ""))!
        
            // Set cell.
            cell = rankingCell
        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            cell.selectionStyle = .none
            cell.textLabel?.text = self.topAssistsData[indexPath.row][1]
            cell.textLabel?.textColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            cell.backgroundColor = UIColor.clear
        }
        
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell
    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Player selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.topScorersTable {
            self.topScorersTable.deselectRow(at: indexPath, animated: true)
            self.selectedPlayerId = self.topScorersData[(indexPath as NSIndexPath).row][3]
        }
        else {
            self.topAssistsTable.deselectRow(at: indexPath, animated: true)
            self.selectedPlayerId = self.topAssistsData[(indexPath as NSIndexPath).row][3]
        }
        
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
