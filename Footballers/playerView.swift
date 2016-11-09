//
//  playerView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 24/07/2016.
//  Copyright © 2016 jp. All rights reserved.
//

//
//  playerView.swift
//  Football Player Test
//
//  Created by Jean-Pierre Laduguie on 22/07/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit
import SideMenu
import NVActivityIndicatorView

class playerView: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Player data passed from previous view controller.
    var playerData: [String: String] = [String: String]()
    
    // Stats tableview.
    var statsTableView: UITableView!
    var topBar: UIView!
    
    // Player.
    var player: Player!
    var isPlayerFavourite: Bool!
    var personalDetails: [String: String]!
    var summaryStats: [[String]]!
    var ratings: [[String]]!
    
    // Team Image.
    var teamImage: UIImage!
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Called when back button pressed.
    @IBAction func backButtonTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Favourites button pressed.
    @IBAction func favouriteButtonTouched(_ sender: UIButton) {
        
        if isPlayerFavourite == true {
            removePlayerFromFavourites(self.playerData["PlayerId"]!)
        }
        else {
            savePlayerToFavourites(self.playerData)
        }
        
        // Negate isPlayerFavourite.
        isPlayerFavourite = !isPlayerFavourite!
        
        // Fade button in/out.
        setFavouriteButton()
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        })
    }
    
    
    func createSubViews() {

        // Stats table view.
        self.statsTableView = UITableView(frame: CGRect(x: 0, y: 160, width: self.view.frame.width, height: self.view.frame.height - 160))
        self.statsTableView.register(playerTopCell.self, forCellReuseIdentifier: NSStringFromClass(playerTopCell.self))
        self.statsTableView.register(playerSecondCell.self, forCellReuseIdentifier: NSStringFromClass(playerSecondCell.self))
        self.statsTableView.register(playerRatingCell.self, forCellReuseIdentifier: NSStringFromClass(playerRatingCell.self))
        self.statsTableView.register(playerStatCell.self, forCellReuseIdentifier: NSStringFromClass(playerStatCell.self))
        self.statsTableView.register(playerTitleCell.self, forCellReuseIdentifier: NSStringFromClass(playerTitleCell.self))
        self.statsTableView.delegate = self
        self.statsTableView.dataSource = self
        self.statsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.statsTableView.backgroundColor = lightGrey
        self.statsTableView.alpha = 0
        self.view.addSubview(self.statsTableView)
        self.view.bringSubview(toFront: self.topBar)
        
        // Player image
        // Get the image from the player's url, and create an imageView for it. Try except needed in case player has no image.
        var profileImage = UIImage(named: "defaultPlayerImage.png")
        
        // Check whether image is available.
        do {
            let imageData = try Data(contentsOf: URL(string: self.player.imageUrl)!, options: NSData.ReadingOptions())
            profileImage = UIImage(data: imageData)
        } catch {
            print("No player image found.")
        }
        
        // Create circle shape from image.
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.frame = CGRect(x: self.view.frame.size.width/2 - 32.5, y: 15, width: 65, height: 90)
        profileImageView.alpha = 0
        self.view.addSubview(profileImageView)
        
        // Name label.
        let nameLabel: UILabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 40)
        nameLabel.text = self.personalDetails["Name"]
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        nameLabel.alpha = 0
        self.view.addSubview(nameLabel)
        
        // Team label.
        let teamLabel: UILabel = UILabel()
        teamLabel.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: 40)
        teamLabel.text = self.personalDetails["Team"]
        teamLabel.textColor = UIColor.white
        teamLabel.textAlignment = NSTextAlignment.center
        teamLabel.backgroundColor = UIColor.clear
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
        teamLabel.alpha = 0
        self.view.addSubview(teamLabel)
        
        UIView.animate(withDuration: 1.0, animations: {
            profileImageView.alpha = 1.0
            nameLabel.alpha = 1.0
            teamLabel.alpha = 1.0
            self.statsTableView.alpha = 1.0
            self.activityIndicator.alpha = 0.0
            }, completion: { (complete: Bool) in
                self.activityIndicator.removeFromSuperview()
                return
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check whether player is in favourites, to know which button to use for navigation bar.
        isPlayerFavourite = isPlayerInFavourites(self.playerData["PlayerId"]!)
        
        // Set background.
        self.view.backgroundColor = lightGrey
        
        // Top bar.
        self.topBar = UIView()
        self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.topBar.backgroundColor = darkGrey
        self.view.addSubview(self.topBar)
        
        // Shadow effect.
        self.topBar.layer.shadowRadius = 1
        self.topBar.layer.shadowOpacity = 1
        self.topBar.layer.shadowColor = UIColor.black.cgColor
        self.topBar.layer.shadowOffset = CGSize.zero
        self.topBar.layer.shouldRasterize = true
        self.topBar.layer.shadowPath = UIBezierPath(rect: topBar.bounds).cgPath
        
        // Create loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Back bar button.
        let backButton = UIButton(type: UIButtonType.custom) as UIButton
        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        backButton.setImage(UIImage(named: "backButton.png"), for: UIControlState())
        backButton.addTarget(self, action: #selector(playerView.backButtonTouched(_:)), for:.touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Favourite bar button.
        setFavouriteButton()
        
        // Get the data in the background, and once it has finished create all the subviews.
        DispatchQueue.global(qos: .background).async {
            
            // Get the data needed for the tableViews.
            self.player = Player(id: self.playerData["PlayerId"]!)
            self.personalDetails = self.player.getPersonalDetails()
            self.ratings = self.player.ratings
            
            // Get team image.
            self.teamImage = UIImage(named: "team.png")
            
            // Check whether image is available.
            do {
                let imageData = try Data(contentsOf: URL(string: self.player.teamImageUrl)!, options: NSData.ReadingOptions())
                self.teamImage = UIImage(data: imageData)
            } catch {
                print("No team image found.")
            }
            
            DispatchQueue.main.async {
                // Create all the subViews with the data,
                self.createSubViews()
            }
        }
    
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.player?.getSummaryStats().count)! + 8)
    }
    
    // Set up tableview cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // If top cell.
        if (indexPath as NSIndexPath).row == 0 {
            
            // Create cell.
            let topCell: playerTopCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerTopCell.self), for: indexPath) as! playerTopCell
            
            // Set values.
            let image = UIImage(named: (self.personalDetails["RegionCode"])!)
            
            topCell.flagImage.image = image
            topCell.countryLabel.text = self.personalDetails["Nationality"]
            topCell.ageLabel.text = self.personalDetails["Age"]
            topCell.teamLabel.text = self.personalDetails["Team"]
            topCell.teamImage.image = self.teamImage
            
            // Set cell.
            cell = topCell
            
        }
        // Second cell.
        else if (indexPath as NSIndexPath).row == 1 {
            // Create cell.
            let secondCell: playerSecondCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerSecondCell.self), for: indexPath) as! playerSecondCell
            
            // Set values.
            secondCell.heightValueLabel.text = self.personalDetails["Height"]
            secondCell.numberValueLabel.text = self.personalDetails["Jersey"]
            secondCell.weightValueLabel.text = self.personalDetails["Weight"]
            
            // Set cell.
            cell = secondCell
        }
        // Title cell.
        else if ((indexPath as NSIndexPath).row == 2 || (indexPath as NSIndexPath).row == 7) {
            // Create cell.
            let titleCell: playerTitleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerTitleCell.self), for: indexPath) as! playerTitleCell
            
            // Set cell.
            cell = titleCell
        }
        // Rating Cells.
        else if ((indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 4 || (indexPath as NSIndexPath).row == 5 || (indexPath as NSIndexPath).row == 6) {
            
            // Create cell.
            let ratingCell: playerRatingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerRatingCell.self), for: indexPath) as! playerRatingCell
            
            ratingCell.statNameLabel.text = self.ratings[(indexPath as NSIndexPath).row - 3][0]
            ratingCell.statValueLabel.text = self.ratings[(indexPath as NSIndexPath).row - 3][1]
            
            let value = Float(self.ratings[(indexPath as NSIndexPath).row - 3][1])
            let barWidth: Int = Int((Float(value! * Float(self.view.frame.width - 40)) / Float(100.0)))
            ratingCell.statBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
            ratingCell.statBar.backgroundColor = getRatingColour(value: Int(self.ratings[(indexPath as NSIndexPath).row - 3][1])!)
            
            // Fade items in.
            UIView.animate(withDuration: 1.0, animations: {
                ratingCell.statBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
            })
            
            // Set cell.
            cell = ratingCell
        }
        else {
        
            // Create cell.
            let statCell: playerStatCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerStatCell.self), for: indexPath) as! playerStatCell
            
            statCell.statNameLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][0]
            statCell.statValueLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][1]
            
            // Set cell.
            cell = statCell
            
        }
        
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell

    }
    
    // Change height for specific rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1 {
            return 90.0
        }
        else if ((indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 4 || (indexPath as NSIndexPath).row == 5 || (indexPath as NSIndexPath).row == 6) {
            return 60.0
        }
        else if ((indexPath as NSIndexPath).row == 2 || (indexPath as NSIndexPath).row == 7) {
            return 21.0
        }
        else {
            return 40.0
        }
    }
    
    // Set favourite button.
    func setFavouriteButton() {
        
        let favouriteButton = UIButton(type: UIButtonType.custom) as UIButton
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        if isPlayerFavourite == true {
            favouriteButton.setImage(UIImage(named: "favouriteButtonFull.png"), for: UIControlState())
        }
        else {
            favouriteButton.setImage(UIImage(named: "favouriteButtonEmpty.png"), for: UIControlState())
        }
        favouriteButton.addTarget(self, action: #selector(playerView.favouriteButtonTouched(_:)), for:.touchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = favouriteButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

