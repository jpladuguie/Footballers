//
//  playerView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 24/07/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class playerView: templateViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Player data passed from previous view controller. Includes only basic information such as PlayerId, 
    // Name and RegionCode needed to load the player data/check whether they are in Favourites.
    var playerData: [String: String]!
    
    // Main player class which handles all the data associated with the player.
    var player: Player!
    
    // Boolean value which is true if the player is in Favourites.
    var isPlayerFavourite: Bool!
    
    // The main view which occupies the upper part of the Player view. Within it is the player photo, name and team.
    var topBar: UIView!
    
    // Player and team crest image declarations.
    var playerImage: UIImage!
    var teamImage: UIImage!
    
    
    /* viewDidLoad() */
    
    // Called as soon as the view loads.
    // It doesn't call its parent's viewDidLoad to prevent a nav bar being created.
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Player
        
        // Check whether the player is in favourites, to know which button to use for navigation bar.
        // If the player is in favourites, the star must be filled white, else it is only an outline.
        self.isPlayerFavourite = isPlayerInFavourites(self.playerData["PlayerId"]!)
        
        // Set the background colour to light grey.
        self.view.backgroundColor = lightGrey
        
        // Create the top bar view, and set its colour to dark grey.
        self.topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        self.topBar.backgroundColor = darkGrey
        self.view.addSubview(self.topBar)
        
        // Create the loading activity indicator.
        self.activityIndicator = configureActivityIndicator(viewController: self)
        self.view.addSubview(self.activityIndicator)
        
        // Create the error label.
        createErrorLabel()
        
        // Create the back button and favourite button and add them to the navigation bar.
        self.setNavBarButtons()
        
        // Keep the table view in position.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Initialise the queue.
        self.queue = OperationQueue()
        
        // Get the data and create the table view.
        self.getData()
        
    }
    
    /* Table View Functions */
    
    // Set the number of rows in table view.
    // 17 rows are needed:
    //  - The top two rows which show information such as shirt number, nationality and height.
    //  - A divider row.
    //  - 4 rating cells with horizontal bars.
    //  - Another divider row.
    //  - 9 rows which show various statistics such as goals scored and yellow cards.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    // Set up the individual cells in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the current row.
        let row = (indexPath as NSIndexPath).row
        
        // Create a gerneric cell.
        var cell:UITableViewCell
        
        // Create the top cell.
        if row == 0 {
            
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
        else if row == 1 {
            
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
        else if row == 2 || row == 7 {
            
            // Create a cell from the playerDividerCell class.
            let divider: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            // Set the main cell to the new one.
            cell = divider
        }
            
        // Create rating cells. Each one has the name of the rating, the value, and a horizontal bar chart.
        else if row > 2 && row < 7 {
            
            // Create a cell from the playerCell class.
            let ratingCell: playerCell = tableView.dequeueReusableCell( withIdentifier: "rating", for: indexPath) as! playerCell
            
            // Disable selection.
            ratingCell.selectionStyle = .none
            
            // Set the name label.
            ratingCell.nameLabel.frame = CGRect(x: 20, y: 0, width: ((UIScreen.main.bounds.width / 3) * 2), height: 35)
            ratingCell.nameLabel.text = self.player.ratings[(indexPath as NSIndexPath).row - 3][0]
            ratingCell.contentView.addSubview(ratingCell.nameLabel)
            
            // Add the rating bar.
            ratingCell.contentView.addSubview(ratingCell.ratingBar)
            
            // Get the rating value as a float.
            let ratingValue = Float(self.player.ratings[(indexPath as NSIndexPath).row - 3][1])
            
            // Get the bar width depending on the value and the screen width.
            // The larger the value, the longer the bar.
            let barWidth: Int = Int((Float(ratingValue! * Float(self.view.frame.width - 40)) / Float(100.0)))
            
            // Set the bar's colour depending on the strength of the rating.
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
        
            // Create a cell from the playerCell class.
            let statCell: playerCell = tableView.dequeueReusableCell( withIdentifier: "stat", for: indexPath) as! playerCell
            
            // Disable selection.
            statCell.selectionStyle = .none
            
            // Set the name label.
            statCell.contentView.addSubview(statCell.nameLabel)
            statCell.nameLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][0]
            
            // Set the value label.
            statCell.contentView.addSubview(statCell.valueLabel)
            statCell.valueLabel.text = self.player?.getSummaryStats()[(indexPath as NSIndexPath).row - 8][1]
        
            // Set the main cell to the new one.
            cell = statCell
            
        }
        
        // Set the cells anchor point to prevent it moving unexpectedly, and return it.
        cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell
    }
    
    // Change the height of specific rows in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get the row.
        let row = (indexPath as NSIndexPath).row
        
        switch row {
        // Height of the top two rows showing personal information.
        case 0..<2:
            return 90.0
        // Height of divider.
        case 2:
            return 20.0
        // Height of the rating cells.
        case 3..<7:
            return 60.0
        // Height of divider.
        case 7:
            return 20
        // Height of the statistic cells.
        default:
            return 40.0
        }
    
    }
    
    /* Data Functions */
    
    // Get the data needed for the view.
    override func getData() {
        
        // Cancel any pending operations.
        self.queue.cancelAllOperations()
        
        // Define the operation.
        self.getDataOperation = BlockOperation()
        
        // Run in the background to prevent the UI from freezing.
        self.getDataOperation.addExecutionBlock {
            
            // Get the data.
            self.player = Player(id: self.playerData["PlayerId"]!)
                
            // If the data has been successfully received, create all the subViews with the data.
            if self.player.dataFetched == true {
                
                // Fetch the images once the data has successfully be received, as the data contains the image urls so 
                // The images have to wait for the data to be received.
                self.getImages()
                
                // Before updating the view, make sure the operation hasn't been canceled.
                if !self.getDataOperation.isCancelled {
                    
                    // Execute on the main thread.
                    OperationQueue.main.addOperation({
                        // Create all the sub views with the data.
                        self.createSubViews()
                    })
                }
            }
                
            // Otherwise, display the error message.
            else {
                // Before updating the view, make sure the operation hasn't been canceled.
                if !self.getDataOperation.isCancelled {
                    
                    // Execute on the main thread.
                    OperationQueue.main.addOperation({
                        
                        // Fade out activity indicator and fade in the error label.
                        self.transitionBetweenViews(firstView: self.activityIndicator, secondView: self.errorLabel, removeFirstView: true)
                    })
                }
            }
        }
        
        // Add the operation to the queue to execute in a seperate thread.
        self.queue.addOperation(self.getDataOperation)
    }
    
    
    // Get the images from the API, such as player image and team image.
    func getImages() {
        
        // Attempt to get the player image from the API.
        self.playerImage = getImage(url: self.player.photoUrl!, type: .Player)
        
        // Attempt to get the team image from the API.
        self.teamImage = getImage(url: self.player.teamPhotoUrl!, type: .Team)

    }
    
    /* Navigation bar functions. */
    
    // Create the back button and favourite button and add them to the navigation bar.
    func setNavBarButtons() {
        
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
        favouriteButton.addTarget(self, action: #selector(playerView.favouriteButtonTouched(_:)), for:.touchUpInside)
        
        // If the player is currently in favourites, set the image to the filled star.
        if isPlayerFavourite == true {
            favouriteButton.setImage(UIImage(named: "favouriteButtonFull.png"), for: UIControlState())
        }
        // Otherwise, set it to the empty star.
        else {
            favouriteButton.setImage(UIImage(named: "favouriteButtonEmpty.png"), for: UIControlState())
        }
        
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
        setNavBarButtons()
        
        // Set the button's alpha to zero, and fade it back in to create a transition between the two images.
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        })
    }
    
    /* Other functions */
    
    // Create all the subviews and add them to the main view.
    // Includes the player image, name, team name, and main table view.
    // Set the alpha of each view to 0.0 so that they can be faded in when the view loads.
    func createSubViews() {
        
        // Create the image view for the player image.
        let playerImageView = UIImageView(image: self.playerImage)
        playerImageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 32.5, y: 15, width: 65, height: 90)
        playerImageView.alpha = 0
        
        // Create the name label for the player's name.
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40))
        nameLabel.text = self.player.personalDetails["Name"]
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        nameLabel.alpha = 0
        
        // Create the team label for the player's team.
        let teamLabel = UILabel(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: 40))
        teamLabel.text = self.player.personalDetails["Team"]
        teamLabel.textColor = UIColor.white
        teamLabel.textAlignment = NSTextAlignment.center
        teamLabel.backgroundColor = UIColor.clear
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
        teamLabel.alpha = 0
        self.view.addSubview(teamLabel)
        
        // Create the main table view.
        self.tableView = UITableView(frame: CGRect(x: 0, y: 160, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220))
        // Register the seperate cell classes.
        self.tableView.register(playerTopCell.self, forCellReuseIdentifier: NSStringFromClass(playerTopCell.self))
        self.tableView.register(playerSecondCell.self, forCellReuseIdentifier: NSStringFromClass(playerSecondCell.self))
        self.tableView.register(playerCell.self, forCellReuseIdentifier: "rating")
        self.tableView.register(playerCell.self, forCellReuseIdentifier: "stat")
        self.tableView.register(dividerCell.self, forCellReuseIdentifier: NSStringFromClass(dividerCell.self))
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = lightGrey
        // Set the alpha to zero so it can be faded in.
        self.tableView.alpha = 0
        
        // Add the sub views to the main view in the correct order.
        self.view.addSubview(playerImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(self.tableView)
        
        // Fade the views in.
        UIView.animate(withDuration: 0.5, animations: {
            // Fade the items in the top view in first.
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
    
    // Prevent the refresh control being called when the table view is scrolled, as no refresh control is needed for Player view.
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

