//
//  imageRankingCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 20/12/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class imageRankingCell: UITableViewCell {

    // Position in the table.
    var profilePhoto: UIImageView!
    // Flag image of the player's country.
    var flagImage: UIImageView!
    // Player's name.
    var nameLabel: UILabel!

    var teamLabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .gray
        
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.layoutMargins = UIEdgeInsets.zero
        
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: 85, y: 55, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Name label.
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRect(x: 85, y: 0, width: self.contentView.frame.width - 105, height: 40)
        self.nameLabel.textAlignment = .left
        self.nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.nameLabel)
       
        // Team label.
        self.teamLabel = UILabel()
        self.teamLabel.frame = CGRect(x: 85, y: 25, width: self.contentView.frame.width - 105, height: 30)
        self.teamLabel.textAlignment = .left
        self.teamLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
        self.teamLabel.textColor = UIColor.white
        self.teamLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.teamLabel)

        // Profile image.
        self.profilePhoto = UIImageView()
        self.profilePhoto.frame = CGRect(x: 20, y: 4.5, width: 48.75, height: 67.5)
        self.contentView.addSubview(self.profilePhoto)
        
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
