//
//  rankingTableCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 21/10/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

// Cell used in any table view which displays data about multiple players, with each row representing a player.
class rankingTableCell: UITableViewCell {
    
    // Position in the table.
    var positionLabel: UILabel!
    // Flag image of the player's country.
    var flagImage: UIImageView!
    // Player's name.
    var nameLabel: UILabel!
    // The statistic value, such as goals scored.
    var statValueLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .gray
        
        // Position label.
        self.positionLabel = UILabel()
        self.positionLabel.frame = CGRect(x: 20, y: 0, width: 30, height: 40)
        self.positionLabel.textAlignment = .right
        self.positionLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.positionLabel.textColor = UIColor.white
        self.positionLabel.backgroundColor = UIColor.clear
        self.addSubview(self.positionLabel)
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: 60, y: 11.5, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Name label.
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRect(x: 95, y: 0, width: self.contentView.frame.width, height: 40)
        self.nameLabel.textAlignment = .left
        self.nameLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.backgroundColor = UIColor.clear
        self.addSubview(self.nameLabel)
        
        // Stat value label.
        self.statValueLabel = UILabel()
        self.statValueLabel.frame = CGRect(x: self.contentView.frame.width, y: 0, width: 35, height: 40)
        self.statValueLabel.textAlignment = .right
        self.statValueLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.statValueLabel.textColor = UIColor.white
        self.statValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.statValueLabel)
        
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
