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

// The main home View Controller.
class homeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // The data and Table View for the top scorers list.
    var topScorersTable: UITableView!
    var topScorersData = [[String]]()
    
    // The data and Table View for the most assists horizontal bar chart.
    var topAssistsTable: UITableView!
    var topAssistsData = [[String]]()
    
    // The data and player stats for the top passer statistics.
    var topPasserData = [[String]]()
    var topPassingPlayerTitle: UIButton!
    
    // The scrollView and mainView views.
    var scrollView: UIScrollView!
    var mainView: UIView!
    
    // The player id or ranking type needed for a segue when a player or ranking table is selected.
    var selectedPlayerData = [String: String]()
    var selectedRanking: String?
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Charts.
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var AssistsChartView: HorizontalBarChartView!
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "homeMenuSegue", sender: nil)
    }
    
    // Handle buttons being pressed.
    @IBAction func subTitlePressed(sender: UIButton) {
        switch sender.tag {
            case 0:
                self.selectedRanking = "goal"
                performSegue(withIdentifier: "homeRankingSegue", sender: nil)
            case 1:
                self.selectedRanking = "assistTotal"
                performSegue(withIdentifier: "homeRankingSegue", sender: nil)
            default:
                print("Error: inocorrect subTitle identifier.")
        }
    }
    
    // Initiate all the subViews, and fade them in.
    func createSubViews() {
        
        // Add titles and subtitles.
        addTitle(yPosition: 110, text: "Goals and Assists")
        addTitle(yPosition: 600, text: "Passing")
        addSubtitle(yPosition: 165, text: "Top Scorers", tag: 0)
        addSubtitle(yPosition: 415, text: "Most Assists", tag: 1)
        
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
        
        // Assists bar chart
        AssistsChartView.frame = CGRect(x: 12, y: 450, width: self.view.frame.width + 30, height: 140)
        AssistsChartView = configureHorizontalBarChart(barChart: AssistsChartView, values: [self.topAssistsData[0][3], self.topAssistsData[1][3], self.topAssistsData[2][3]] )
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
        
        // Passing pie chart
        pieChartView.frame = CGRect(x: self.view.frame.width - 160, y: 650, width: 140 , height: 140)
        pieChartView = configurePieChart(pieChart: pieChartView, chartValue: Double(self.topPasserData[0][3])!)
        self.mainView.addSubview(pieChartView)
        
        self.topPassingPlayerTitle = UIButton(frame: CGRect(x: 20, y: 650, width: self.view.frame.width - 160, height: 30))
        self.topPassingPlayerTitle.tintColor = UIColor.white
        self.topPassingPlayerTitle.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.topPassingPlayerTitle.setTitle(self.topPasserData[0][1], for: .normal)
        self.topPassingPlayerTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.topPassingPlayerTitle.addTarget(self, action: #selector(subTitlePressed), for: .touchUpInside)
        self.topPassingPlayerTitle.alpha = 0.0
        self.mainView.addSubview(self.topPassingPlayerTitle)
        
        // Fade items in.
        UIView.animate(withDuration: 1.0, animations: {
            self.topScorersTable.alpha = 1.0
            self.topPassingPlayerTitle.alpha = 1.0
            // Fade out activity indicator.
            self.activityIndicator.alpha = 0.0
            }, completion: { (complete: Bool) in
                // Once animations have finished.
                UIView.animate(withDuration: 0.5, animations: {
                    // Fade in values for horizontal bar chart once it has finished animating.
                    self.topAssistsTable.alpha = 1.0
                    // Remove activity indicator from view.
                    self.activityIndicator.removeFromSuperview()
                    })
                return
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the current page and title.
        currentPage = "Home"
        self.title = "Home"
        
        // Set up the views. The screen is taken up by the scrollView, and inside the scrollView
        // Is the mainView. Everytime a subView is added to the screen, it must be added to the
        // mainView.
        self.mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2000))
        
        // Set up the scrollView. This is needed to fit everything on the screen and allow the 
        // View to be scrolled vertically.
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.backgroundColor = lightGrey
        self.scrollView.contentSize = self.mainView.bounds.size
        self.scrollView.addSubview(self.mainView)
        view.addSubview(self.scrollView)
        
        // Keep scrollView in position.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Set up the View Controller.
        setUpView(viewController: self)
        
        // Create loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Get the data in the background, and once it has finished create all the subviews.
        DispatchQueue.global(qos: .background).async {
            // Get the data needed for the tableViews.
            self.topScorersData = getPlayerRankings(type: "goal", numberToGet: "5")
            self.topAssistsData = getPlayerRankings(type: "assistTotal", numberToGet: "3")
            self.topPasserData = getPlayerRankings(type: "passSuccess", numberToGet: "1")
            DispatchQueue.main.async {
                // Create all the subViews with the data,
                self.createSubViews()
            }
        }
    }
    
    // Set the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Top Scorers table.
        if tableView == self.topScorersTable {
            return 5
        }
        // Top Assists table.
        else {
            return 3
        }
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // If the tableView is topScorersTable, create a custom cell.
        if tableView == self.topScorersTable {
        
            // Create the custom cell using the rankingTableCell class..
            let rankingCell: rankingTableCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(rankingTableCell.self), for: indexPath) as! rankingTableCell
            
            // Move the everything slightly to the left, as the ranking numbers will only
            // Be between 1 and 5, so space for only one digit is needed and not 3 which
            // Is the default.
            rankingCell.rankingLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
            rankingCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
            rankingCell.statNameLabel.frame = CGRect(x: 75, y: 0, width: 320, height: 40)
            
            // Assign the correct values to the tableView cell.
            rankingCell.rankingLabel.text = String(indexPath.row + 1)
            rankingCell.statNameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][1]
            rankingCell.statValueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row][3]
            rankingCell.flagImage.image = UIImage(named: String(self.topScorersData[(indexPath as NSIndexPath).row][2].uppercased() + ""))!
        
            // Set the cell.
            cell = rankingCell
        }
        // If the tableView is the topAssistsTable, use the default tableView cell.
        else {
            
            // Create the cell.
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            // Prevent the cell being selected and assign the correct data.
            cell.selectionStyle = .none
            cell.textLabel?.text = self.topAssistsData[indexPath.row][1]
            cell.textLabel?.textColor = lightGrey
            cell.backgroundColor = UIColor.clear
        }
        
        // Return the cell.
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell
    }
    
    // Set the row height for all tableViews to 40.0.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    // Called when a tableViewCell is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select the correct playerId depending on which tableView the selected cell is in.
        let playerData: [String]
        if tableView == self.topScorersTable {
            self.topScorersTable.deselectRow(at: indexPath, animated: true)
            playerData = self.topScorersData[(indexPath as NSIndexPath).row]
        }
        else {
            self.topAssistsTable.deselectRow(at: indexPath, animated: true)
            playerData = self.topAssistsData[(indexPath as NSIndexPath).row]
        }
        
        // Assign value to selectedPlayerData.
        self.selectedPlayerData["playerId"] = playerData[0]
        self.selectedPlayerData["name"] = playerData[1]
        self.selectedPlayerData["regionCode"] = playerData[2]
        
        // Perform the segue to the player view.
        performSegue(withIdentifier: "homePlayerSegue", sender: self)
    }
    
    // Called when a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If a player has been selected, send the correct playerId to the playerView.
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
    
    // Add a title and divider to the view. The x position and size of the title is constant,
    // But the y position can be varied depending on how far down the screen the title needs to be.
    func addTitle(yPosition: Double, text: String) {
        
        // Create the title.
        let title = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: Double(self.view.frame.width - 40.0), height: 30.0))
        // Set the colour to white, add the text and add to view.
        title.font = UIFont.systemFont(ofSize: 28.0)
        title.text = text
        title.textColor = UIColor.white
        title.alpha = 0.0
        self.mainView.addSubview(title)
        
        // Create the divider.
        let divider = UIImageView(image: UIImage(named: "whiteLine.png"))
        // Set its size and add it to view.
        divider.frame = CGRect(x: 20.0, y: yPosition + 40.0, width: Double(self.view.frame.width - 40.0), height: 1.0)
        divider.alpha = 0.0
        self.mainView.addSubview(divider)
        
        // Fade the title and divider in.
        UIView.animate(withDuration: 1.0, animations: {
            title.alpha = 1.0
            divider.alpha = 1.0
        })
    }
    
    // Add a subtitle to view depending on the y position, as the x position and size are constant.
    // The tag is needed so that when the subtitle is selected, the correct segue is performed.
    func addSubtitle(yPosition: Double, text: String, tag: Int) {
        
        // Create the subtitle.
        let subTitle = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: Double(self.view.frame.width - 40.0), height: 30.0))
        // Set the colour to white and add the title.
        subTitle.tintColor = UIColor.white
        subTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        subTitle.setTitle(text, for: .normal)
        subTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        // Add the tag to the button and set the function to be called when it's pressed.
        subTitle.addTarget(self, action: #selector(subTitlePressed), for: .touchUpInside)
        subTitle.tag = tag
        subTitle.alpha = 0.0
        // Add it to view.
        self.mainView.addSubview(subTitle)
        
        // Fade the subtitle in.
        UIView.animate(withDuration: 1.0, animations: {
            subTitle.alpha = 1.0
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
