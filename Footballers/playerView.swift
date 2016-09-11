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
    
    // Activity indicator.
    var activityIndicator: NVActivityIndicatorView!
    
    // Back button pressed.
    @IBAction func backButtonTouched(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Favourites button pressed.
    @IBAction func favouriteButtonTouched(sender: UIButton) {
        // Negate isPlayerFavourite.
        isPlayerFavourite = !isPlayerFavourite!
        
        // Fade button in/out.
        setFavouriteButton()
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
        
        UIView.animateWithDuration(0.25, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        })
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Declare player
        self.player = Player(id: self.playerData["playerId"]!)
        self.personalDetails = player.getPersonalDetails()
        
        // Stats table view.
        self.statsTableView = UITableView(frame: CGRect(x: 0, y: 160, width: 320, height: self.view.frame.height - 160))
        self.statsTableView.registerClass(playerTopCell.self, forCellReuseIdentifier: NSStringFromClass(playerTopCell))
        self.statsTableView.registerClass(playerSecondCell.self, forCellReuseIdentifier: NSStringFromClass(playerSecondCell))
        self.statsTableView.registerClass(playerStatCell.self, forCellReuseIdentifier: NSStringFromClass(playerStatCell))
        self.statsTableView.delegate = self
        self.statsTableView.dataSource = self
        self.statsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.statsTableView.backgroundColor = UIColor.clearColor()
        self.statsTableView.alpha = 0
        self.view.addSubview(self.statsTableView)
        self.view.bringSubviewToFront(self.topBar)
        
        // Player image
        // Get the image from the player's url, and create an imageView for it. Try except needed in case player has no image.
        var profileImage = UIImage(named: "defaultPlayerImage.png")
        
        // Check whether image is available.
        do {
            let imageData = try NSData(contentsOfURL: NSURL(string: player!.imageUrl)!, options: NSDataReadingOptions())
            profileImage = UIImage(data: imageData)
        } catch {
            print("No player image found.")
        }
        
        // Create circle shape from image.
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.frame = CGRectMake(self.view.frame.size.width/2 - 37.5, 15, 75, 112.5)
        profileImageView.alpha = 0
        self.view.addSubview(profileImageView)
        
        // Create a view on top of the imageView and cut a circle out of it.
        let topView = UIView(frame: CGRectMake(self.view.frame.size.width/2 - 37.5, 15, 75, 112.5))
        let maskLayer = CAShapeLayer()
        let radius : CGFloat = profileImageView.bounds.width/2
        let path = UIBezierPath(rect: profileImageView.bounds)
        path.addArcWithCenter(CGPoint(x: profileImageView.bounds.width/2, y: 50.0), radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        maskLayer.path = path.CGPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        topView.layer.mask = maskLayer
        topView.clipsToBounds = true
        topView.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.view.addSubview(topView)
        
        // Name label.
        let nameLabel: UILabel = UILabel()
        nameLabel.frame = CGRectMake(0, 100, self.view.frame.size.width, 40)
        nameLabel.text = self.personalDetails[0][1]
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        nameLabel.alpha = 0
        self.view.addSubview(nameLabel)
        
        // Team label.
        let teamLabel: UILabel = UILabel()
        teamLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 40)
        teamLabel.text = self.personalDetails[1][1]
        teamLabel.textColor = UIColor.whiteColor()
        teamLabel.textAlignment = NSTextAlignment.Center
        teamLabel.backgroundColor = UIColor.clearColor()
        teamLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightUltraLight)
        teamLabel.alpha = 0
        self.view.addSubview(teamLabel)
        
        UIView.animateWithDuration(1.0, animations: {
            profileImageView.alpha = 1.0
            nameLabel.alpha = 1.0
            teamLabel.alpha = 1.0
            self.statsTableView.alpha = 1.0
            self.activityIndicator.alpha = 0.0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check whether player is in favourites, to know which button to use for navigation bar.
        isPlayerFavourite = isPlayerInFavourites(self.playerData["playerId"]!)
        
        // Set background.
        self.view.backgroundColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Top bar.
        self.topBar = UIView()
        self.topBar.frame = CGRectMake(0, 0, self.view.frame.width, 160)
        self.topBar.backgroundColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.view.addSubview(self.topBar)
        
        // Shadow effect.
        self.topBar.layer.shadowRadius = 1
        self.topBar.layer.shadowOpacity = 1
        self.topBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.topBar.layer.shadowOffset = CGSizeZero
        self.topBar.layer.shouldRasterize = true
        self.topBar.layer.shadowPath = UIBezierPath(rect: topBar.bounds).CGPath
        
        // Loading activity indicator.
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width/2 - 25), y: (self.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.BallClipRotatePulse, color: UIColor.whiteColor())
        self.activityIndicator.startAnimation()
        self.view.addSubview(self.activityIndicator)
        
        // Back bar button.
        let backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = CGRectMake(0, 0, 25, 25)
        backButton.setImage(UIImage(named: "backButton.png"), forState: .Normal)
        backButton.addTarget(self, action: #selector(playerView.backButtonTouched(_:)), forControlEvents:.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Favourite bar button.
        setFavouriteButton()
    
    }
    
    // Number of rows in tableview.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.player?.getSummaryStats().count)! + 1)
    }
    
    
    
    // Set up tableview cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell
        
        // If top cell.
        if indexPath.row == 0 {
            
            // Create cell.
            let topCell: playerTopCell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(playerTopCell), forIndexPath: indexPath) as! playerTopCell
            
            // Set values.
            topCell.flagImage.image = UIImage(named: self.personalDetails[5][1].uppercaseString)!
            topCell.countryLabel.text = self.personalDetails[6][1]
            topCell.ageLabel.text = self.personalDetails[2][1]
            
            // Get team image.
            var teamImage = UIImage(named: "team.png")
            
            // Check whether image is available.
            do {
                let imageData = try NSData(contentsOfURL: NSURL(string: self.player.teamImageUrl)!, options: NSDataReadingOptions())
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
        else if indexPath.row == 1 {
            // Create cell.
            let secondCell: playerSecondCell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(playerSecondCell), forIndexPath: indexPath) as! playerSecondCell
            
            // Set values.
            secondCell.heightValueLabel.text = self.personalDetails[3][1]
            secondCell.numberValueLabel.text = self.personalDetails[7][1]
            secondCell.weightValueLabel.text = self.personalDetails[4][1]
            
            // Set cell.
            cell = secondCell
        }
        else {
        
            // Create cell.
            let statCell: playerStatCell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(playerStatCell), forIndexPath: indexPath) as! playerStatCell
            
            statCell.statNameLabel.text = self.player?.getSummaryStats()[indexPath.row - 1][0]
            statCell.statValueLabel.text = self.player?.getSummaryStats()[indexPath.row - 1][1]
            
            // Set cell.
            cell = statCell
            
        }
        
        cell.layer.anchorPointZ = CGFloat(indexPath.row)
        return cell

    }
    
    // Change height for specific rows.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            return 90.0
        }
        return 40.0
    }
    
    // Set favourite button.
    func setFavouriteButton() {
        
        let favouriteButton = UIButton(type: UIButtonType.Custom) as UIButton
        favouriteButton.frame = CGRectMake(0, 0, 25, 25)
        if isPlayerFavourite == true {
            favouriteButton.setImage(UIImage(named: "favouriteButtonFull.png"), forState: .Normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "favouriteButtonEmpty.png"), forState: .Normal)
        }
        favouriteButton.addTarget(self, action: #selector(playerView.favouriteButtonTouched(_:)), forControlEvents:.TouchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = favouriteButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

