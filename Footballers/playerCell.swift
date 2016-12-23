//
//  playerCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 22/12/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerCell: UITableViewCell {
    
    // Player/Stat name.
    var nameLabel: UILabel!
    
    // Stat value.
    var valueLabel: UILabel!
    
    // Position in the table.
    var positionLabel: UILabel!
    
    // Flag image of the player's country.
    var flagImage: UIImageView!
    
    // Player's team.
    var teamLabel: UILabel!
    
    // Player's age.
    var ageLabel: UILabel!
    
    // Player's image.
    var playerImage: UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        
        
       
        
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
