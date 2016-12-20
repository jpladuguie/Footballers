//
//  detailedRankingCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 20/12/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class detailedRankingCell: UITableViewCell {
    
    // Position in the table.
    var positionLabel: UILabel!
    // Flag image of the player's country.
    var flagImage: UIImageView!
    // Player's name.
    var nameLabel: UILabel!
    // The statistic value, such as goals scored.
    var statValueLabel: UILabel!
    
    var playingPositionValueLabel: UILabel!
    var playingPositionLabel: UILabel!
    
    var teamValueLabel: UILabel!
    var teamLabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .gray
        
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.layoutMargins = UIEdgeInsets.zero
        
        
        // Position label.
        self.positionLabel = UILabel()
        self.positionLabel.frame = CGRect(x: 10, y: 5, width: 30, height: 40)
        self.positionLabel.textAlignment = .right
        self.positionLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.positionLabel.textColor = UIColor.white
        self.positionLabel.backgroundColor = UIColor.clear
        self.addSubview(self.positionLabel)
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: 50, y: 16.5, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Name label.
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRect(x: 90, y: 5, width: self.contentView.frame.width, height: 40)
        self.nameLabel.textAlignment = .left
        self.nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.backgroundColor = UIColor.clear
        self.addSubview(self.nameLabel)
        
        // Stat value label.
        self.statValueLabel = UILabel()
        self.statValueLabel.frame = CGRect(x: self.contentView.frame.width - 10, y: 5, width: 50, height: 40)
        self.statValueLabel.textAlignment = .right
        self.statValueLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.statValueLabel.textColor = UIColor.white
        self.statValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.statValueLabel)
        
        
        
        
        
        
        // Name label.
        self.playingPositionLabel = UILabel()
        self.playingPositionLabel.frame = CGRect(x: 50, y: 40, width: 40, height: 30)
        self.playingPositionLabel.textAlignment = .left
        self.playingPositionLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
        self.playingPositionLabel.textColor = UIColor.white
        self.playingPositionLabel.backgroundColor = UIColor.clear
        self.playingPositionLabel.text = "Age"
        self.addSubview(self.playingPositionLabel)
        
        // Name label.
        self.playingPositionValueLabel = UILabel()
        self.playingPositionValueLabel.frame = CGRect(x: 90, y: 40, width: 20, height: 30)
        self.playingPositionValueLabel.textAlignment = .left
        self.playingPositionValueLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
        self.playingPositionValueLabel.textColor = UIColor.white
        self.playingPositionValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.playingPositionValueLabel)

        
        // Name label.
        self.teamLabel = UILabel()
        self.teamLabel.frame = CGRect(x: 130, y: 40, width: 50, height: 30)
        self.teamLabel.textAlignment = .left
        self.teamLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
        self.teamLabel.textColor = UIColor.white
        self.teamLabel.backgroundColor = UIColor.clear
        self.teamLabel.text = "Team"
        self.addSubview(self.teamLabel)
        
        // Name label.
        self.teamValueLabel = UILabel()
        self.teamValueLabel.frame = CGRect(x: 185, y: 40, width: 200, height: 30)
        self.teamValueLabel.textAlignment = .left
        self.teamValueLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
        self.teamValueLabel.textColor = UIColor.white
        self.teamValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.teamValueLabel)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
