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
    var personalDetails: [[String]]!
    var summaryStats: [[String]]!
    var ratings: [[String]]!
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Called when back button pressed.
    @IBAction func backButtonTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Favourites button pressed.
    @IBAction func favouriteButtonTouched(_ sender: UIButton) {
        
        if isPlayerFavourite == true {
            removePlayerFromFavourites(self.playerData["playerId"]!)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Declare player
        self.player = Player(id: self.playerData["playerId"]!)
        self.personalDetails = player.getPersonalDetails()
        self.ratings = player.ratings
        
        // Stats table view.
        self.statsTableView = UITableView(frame: CGRect(x: 0, y: 160, width: self.view.frame.width, height: self.view.frame.height - 160))
        self.statsTableView.register(playerTopCell.self, forCellReuseIdentifier: NSStringFromClass(playerTopCell.self))
        self.statsTableView.register(playerSecondCell.self, forCellReuseIdentifier: NSStringFromClass(playerSecondCell.self))
        self.statsTableView.register(playerRatingCell.self, forCellReuseIdentifier: NSStringFromClass(playerRatingCell.self))
        self.statsTableView.register(playerStatCell.self, forCellReuseIdentifier: NSStringFromClass(playerStatCell.self))
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
            let imageData = try Data(contentsOf: URL(string: player!.imageUrl)!, options: NSData.ReadingOptions())
            profileImage = UIImage(data: imageData)
        } catch {
            print("No player image found.")
        }
        
        // Create circle shape from image.
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.frame = CGRect(x: self.view.frame.size.width/2 - 37.5, y: 15, width: 75, height: 112.5)
        profileImageView.alpha = 0
        self.view.addSubview(profileImageView)
        
        // Create a view on top of the imageView and cut a circle out of it.
        let topView = UIView(frame: CGRect(x: self.view.frame.size.width/2 - 37.5, y: 15, width: 75, height: 112.5))
        let maskLayer = CAShapeLayer()
        let radius : CGFloat = profileImageView.bounds.width/2
        let path = UIBezierPath(rect: profileImageView.bounds)
        path.addArc(withCenter: CGPoint(x: profileImageView.bounds.width/2, y: 50.0), radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        topView.layer.mask = maskLayer
        topView.clipsToBounds = true
        topView.backgroundColor = darkGrey
        self.view.addSubview(topView)
        
        // Name label.
        let nameLabel: UILabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 40)
        nameLabel.text = self.personalDetails[0][1]
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        nameLabel.alpha = 0
        self.view.addSubview(nameLabel)
        
        // Team label.
        let teamLabel: UILabel = UILabel()
        teamLabel.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: 40)
        teamLabel.text = self.personalDetails[1][1]
        teamLabel.textColor = UIColor.white
        teamLabel.textAlignment = NSTextAlignment.center
        teamLabel.backgroundColor = UIColor.clear
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: -1.0)
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
        isPlayerFavourite = isPlayerInFavourites(self.playerData["playerId"]!)
        
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
    
    }
    
    // Number of rows in tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.player?.getSummaryStats().count)! + 6)
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
            let image = UIImage(named: self.personalDetails[5][1].uppercased())
            
            topCell.flagImage.image = image
            topCell.countryLabel.text = self.personalDetails[6][1]
            topCell.ageLabel.text = self.personalDetails[2][1]
            
            // Get team image.
            var teamImage = UIImage(named: "team.png")
            
            // Check whether image is available.
            do {
                let imageData = try Data(contentsOf: URL(string: self.player.teamImageUrl)!, options: NSData.ReadingOptions())
                teamImage = UIImage(data: imageData)
            } catch {
                print("No team image found.")
            }
            
            topCell.teamImage.image = teamImage
            topCell.teamLabel.text = self.personalDetails[1][1]
            
            // Set cell.
            cell = topCell
            
        }
        // Second cell.
        else if (indexPath as NSIndexPath).row == 1 {
            // Create cell.
            let secondCell: playerSecondCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerSecondCell.self), for: indexPath) as! playerSecondCell
            
            // Set values.
            secondCell.heightValueLabel.text = self.personalDetails[3][1]
            secondCell.numberValueLabel.text = self.personalDetails[7][1]
            secondCell.weightValueLabel.text = self.personalDetails[4][1]
            
            // Set cell.
            cell = secondCell
        }
        // Rating Cells.
        else if ((indexPath as NSIndexPath).row == 2 || (indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 4 || (indexPath as NSIndexPath).row == 5) {
            
            // Create cell.
            let ratingCell: playerRatingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerRatingCell.self), for: indexPath) as! playerRatingCell
            
            ratingCell.statNameLabel.text = self.ratings[(indexPath as NSIndexPath).row - 2][0]
            ratingCell.statValueLabel.text = self.ratings[(indexPath as NSIndexPath).row - 2][1]
            
            let value = Float(self.ratings[(indexPath as NSIndexPath).row - 2][1])
            let barWidth: Int = Int((Float(value! * Float(self.view.frame.width - 40)) / Float(100.0)))
            ratingCell.statBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
            ratingCell.statBar.backgroundColor = getRatingColour(value: Int(self.ratings[(indexPath as NSIndexPath).row - 2][1])!)
            
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
            
            statCell.statNameLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 6][0]
            statCell.statValueLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 6][1]
            
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
        else if ((indexPath as NSIndexPath).row == 2 || (indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 4 || (indexPath as NSIndexPath).row == 5) {
            return 60.0
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

