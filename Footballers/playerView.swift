//
//  playerView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 24/07/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class playerView: templateViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Player data passed from previous view controller.
    // Includes only basic information such as PlayerId, Name and RegionCode.
    var playerData: [String: String]!
    
    // Main player class.
    var player: Player!
    
    // Boolean value of whether player is in favourites.
    var isPlayerFavourite: Bool!
    
    // Main views.
    // The playerView class consists of a topBar showing the player's image, name and team name, and a table view 
    // Showing information such as personal details, ratings and statistics.
    var topBar: UIView!
    
    // Player and team images.
    var playerImage: UIImage!
    var teamImage: UIImage!
    
    
    /* Called as soon as the view loads. */
    
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Player
        
        // Check whether the player is in favourites, to know which button to use for navigation bar.
        // If the player is in favourites, the star must be filled white, else it is only an outline.
        self.isPlayerFavourite = isPlayerInFavourites(self.playerData["PlayerId"]!)
        
        // Set the background colour to light grey.
        self.view.backgroundColor = lightGrey
        
        // Create the top bar view, and set its colour to dark grey.
        self.topBar = UIView()
        self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.topBar.backgroundColor = darkGrey
        self.view.addSubview(self.topBar)
        
        // Create the loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Create the error label.
        createErrorLabel()
        
        // Create the back button and favourite button and add them to the navigation bar.
        self.createNavBarButtons()
        
        // Keep the table view in position.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Get the data and create the table view.
        getData()
    }
    
    /* Table View Functions. */
    
    // Set the number of rows in table view.
    // It includes the number of statistic rows, the two top rows displaying personal information, the four ratings rows,
    // And the two divider rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    // Set up the individual cells in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a gerneric cell.
        var cell:UITableViewCell
        
        // Create the top cell.
        if (indexPath as NSIndexPath).row == 0 {
            
            // Create a cell from the playerTopCell class.
            let topCell: playerTopCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerTopCell.self), for: indexPath) as! playerTopCell
            
            // Set the values for the flag image, country name, age, team name and team image.
            topCell.flagImage.image = UIImage(named: (self.player.personalDetails["RegionCode"])!)
            topCell.countryLabel.text = self.player.personalDetails["Nationality"]
            topCell.ageLabel.text = self.player.personalDetails["Age"]
            topCell.teamLabel.text = self.player.personalDetails["Team"]
            topCell.teamImage.image = self.teamImage
            
            // Set the main cell to the new one.
            cell = topCell
        }
            
        // Create the second cell.
        else if (indexPath as NSIndexPath).row == 1 {
            
            // Create a cell from the playerSecondCell class.
            let secondCell: playerSecondCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerSecondCell.self), for: indexPath) as! playerSecondCell
            
            // Set the values for height, weight and shirt number.
            secondCell.heightValueLabel.text = self.player.personalDetails["Height"]
            secondCell.numberValueLabel.text = self.player.personalDetails["Jersey"]
            secondCell.weightValueLabel.text = self.player.personalDetails["Weight"]
            
            // Set the main cell to the new one.
            cell = secondCell
        }
            
        // Create divider cells between personal details and ratings, and ratings and statistics.
        else if ((indexPath as NSIndexPath).row == 2 || (indexPath as NSIndexPath).row == 7) {
            
            // Create a cell from the playerDividerCell class.
            let titleCell: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            // Set the main cell to the new one.
            cell = titleCell
        }
            
        // Create rating cells. Each one has the name of the rating, the value, and a horizontal bar chart.
        else if ((indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 4 || (indexPath as NSIndexPath).row == 5 || (indexPath as NSIndexPath).row == 6) {
            
            // Create a cell from the playerRatingCell class.
            let ratingCell: playerRatingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerRatingCell.self), for: indexPath) as! playerRatingCell
            
            // Set the values of the rating name and its value.
            ratingCell.ratingNameLabel.text = self.player.ratings[(indexPath as NSIndexPath).row - 3][0]
            ratingCell.ratingValueLabel.text = self.player.ratings[(indexPath as NSIndexPath).row - 3][1]
            
            // Get the rating value as a float.
            let ratingValue = Float(self.player.ratings[(indexPath as NSIndexPath).row - 3][1])
            // Get the bar width depending on the value and the screen width.
            let barWidth: Int = Int((Float(ratingValue! * Float(self.view.frame.width - 40)) / Float(100.0)))
            // Create the bar as a UIView and set its colour depending on the strength of the rating.
            ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
            ratingCell.ratingBar.backgroundColor = getRatingColour(value: Int(self.player.ratings[(indexPath as NSIndexPath).row - 3][1])!)
            
            // Animate the rating bar so that it slides in.
            UIView.animate(withDuration: 1.0, animations: {
                ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
            })
            
            // Set the main cell to the new one.
            cell = ratingCell
        }
        
        // Otherwise, the cell is a row in the statistics section.
        else {
        
            // Create a cell from the playerStatCell class.
            let statCell: playerStatCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerStatCell.self), for: indexPath) as! playerStatCell
            
            // Set the values of the statistic name and value.
            statCell.statNameLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][0]
            statCell.statValueLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][1]
            
            // Set the main cell to the new one.
            cell = statCell
            
        }
        
        // Set the cells anchor point to prevent it moving unexpectedly, and return it.
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell
    }
    
    // Change the height of specific rows in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = (indexPath as NSIndexPath).row
        
        // Height of the top two rows showing personal information.
        if row == 0 || row == 1 {
            return 90.0
        }
        // Height of the dividers.
        else if row == 2 || row == 7 {
            return 21.0
        }
        // Height of the rating cells.
        else if row > 2 && row < 7 {
            return 60.0
        }
        // Height of the statistic cells.
        else {
            return 40.0
        }
    }
    
    /* Data Functions */
    
    override func getData() {
        
        // Get the data in the background, and once it has finished create all the subviews.
        DispatchQueue.global(qos: .background).async {
            
            // Get the data.
            self.player = Player(id: self.playerData["PlayerId"]!)
            
            // Called once all the data has been fetched.
            DispatchQueue.main.async {
                
                // If the data has been received, create all the subViews with the data.
                if self.player.dataFetched == true {
                    // Fetch the images once the data has successfully be received, as the data contains the image urls.
                    self.getImages()
                    // Create all the sub views with the data.
                    self.createSubViews()
                }
                    // Otherwise, display the error message.
                else {
                    // Fade out activity indicator.
                    UIView.animate(withDuration: 0.5, animations: {
                        self.activityIndicator.alpha = 0.0
                        }, completion: { (complete: Bool) in
                            // Remove activity indicator from view.
                            self.activityIndicator.removeFromSuperview()
                            // Show error message.
                            UIView.animate(withDuration: 0.5, animations: {
                                self.errorLabel.alpha = 1.0
                            })
                    })
                }
            }
        }
    }
    
    /* Navigation bar functions. */
    
    // Create the back button and favourite button and add them to the navigation bar.
    func createNavBarButtons() {
        
        // Create a back bar button to return to the previous view.
        // Set a custom back button image for the button, and call backButtonTouched() once it has been pressed.
        let backButton = UIButton(type: UIButtonType.custom) as UIButton
        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        backButton.setImage(UIImage(named: "back.png"), for: UIControlState())
        backButton.addTarget(self, action: #selector(playerView.backButtonTouched(_:)), for:.touchUpInside)
        
        // Add the back bar button to the navigation bar.
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Create a favourite button to add/remove the player from favourites.
        // Set a custom image for the button, and call favouriteButtonTouched() once it has been pressed.
        let favouriteButton = UIButton(type: UIButtonType.custom) as UIButton
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        // If the player is currently in favourites, set the image to the filled star.
        if isPlayerFavourite == true {
            favouriteButton.setImage(UIImage(named: "favouriteButtonFull.png"), for: UIControlState())
        }
        // Otherwise, set it to the empty star.
        else {
            favouriteButton.setImage(UIImage(named: "favouriteButtonEmpty.png"), for: UIControlState())
        }
        favouriteButton.addTarget(self, action: #selector(playerView.favouriteButtonTouched(_:)), for:.touchUpInside)
        
        // Add the favourite button to the naviagtion bar.
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = favouriteButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // Called when the back button is pressed.
    @IBAction func backButtonTouched(_ sender: UIButton) {
        // Pop the current player view, and return to the previous view.
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Called when the favourite button is pressed.
    @IBAction func favouriteButtonTouched(_ sender: UIButton) {
        
        // Check whether the player is currently in favourites.
        if isPlayerFavourite == true {
            // If so, remove the player from favourites.
            removePlayerFromFavourites(self.playerData["PlayerId"]!)
        }
        else {
            // Otherwise, add the player to favourites.
            savePlayerToFavourites(self.playerData)
        }
        
        // Negate isPlayerFavourite.
        isPlayerFavourite = !isPlayerFavourite!
        
        // Change the favourite button to the new image.
        createNavBarButtons()
        
        // Set the button's alpha to zero, and fade it back in.
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        })
    }
    
    /* Other functions */
    
    // Create all the subviews and add them to the main view.
    // Includes the player image, name, team name, and main table view.
    func createSubViews() {
        
        // Create the image view for the player image.
        let playerImageView = UIImageView(image: self.playerImage)
        playerImageView.frame = CGRect(x: self.view.frame.size.width/2 - 32.5, y: 15, width: 65, height: 90)
        // Set the alpha to zero so it can be faded in.
        playerImageView.alpha = 0
        self.view.addSubview(playerImageView)
        
        // Create the name label for the player's name.
        let nameLabel: UILabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 40)
        nameLabel.text = self.player.personalDetails["Name"]
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        // Set the alpha to zero so it can be faded in.
        nameLabel.alpha = 0
        self.view.addSubview(nameLabel)
        
        // Create the team label for the player's team.
        let teamLabel: UILabel = UILabel()
        teamLabel.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: 40)
        teamLabel.text = self.player.personalDetails["Team"]
        teamLabel.textColor = UIColor.white
        teamLabel.textAlignment = NSTextAlignment.center
        teamLabel.backgroundColor = UIColor.clear
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
        // Set the alpha to zero so it can be faded in.
        teamLabel.alpha = 0
        self.view.addSubview(teamLabel)
        
        // Create the main table view.
        self.tableView = UITableView(frame: CGRect(x: 0, y: 160, width: self.view.frame.width, height: self.view.frame.height - 220))
        // Register the seperate cell classes.
        self.tableView.register(playerTopCell.self, forCellReuseIdentifier: NSStringFromClass(playerTopCell.self))
        self.tableView.register(playerSecondCell.self, forCellReuseIdentifier: NSStringFromClass(playerSecondCell.self))
        self.tableView.register(playerRatingCell.self, forCellReuseIdentifier: NSStringFromClass(playerRatingCell.self))
        self.tableView.register(playerStatCell.self, forCellReuseIdentifier: NSStringFromClass(playerStatCell.self))
        self.tableView.register(dividerCell.self, forCellReuseIdentifier: NSStringFromClass(dividerCell.self))
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = lightGrey
        // Set the alpha to zero so it can be faded in.
        self.tableView.alpha = 0
        self.view.addSubview(self.tableView)
        
        // Fade views in.
        UIView.animate(withDuration: 0.5, animations: {
            playerImageView.alpha = 1.0
            nameLabel.alpha = 1.0
            teamLabel.alpha = 1.0
            // Fade out the activity indicator, as the data has finished loading.
            self.activityIndicator.alpha = 0.0
            }, completion: { (complete: Bool) in
                // Once the animation has finished, remove the activity indicator from the view.
                self.activityIndicator.removeFromSuperview()
                // Fade the table view in.
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.alpha = 1.0
                })
        })
    }
    
    // Get the images from the API, such as player image and team image.
    func getImages() {
        
        // Attempt to get the player image from the API.
        self.playerImage = getPlayerImage(url: self.player.photoUrl!)
        
        // Attempt to get the team image from the API.
        do {
            let imageData = try Data(contentsOf: URL(string: self.player.teamPhotoUrl!)!, options: NSData.ReadingOptions())
            self.teamImage = UIImage(data: imageData)
        } catch {
            // If the image cannot be fetched from the API, set it to the default one.
            self.teamImage = UIImage(named: "team.png")
            print("No team image found for " + self.player.personalDetails["Team"]! + ".")
        }
    }
    
    // Reload data when the table view has been pulled down and released.
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

