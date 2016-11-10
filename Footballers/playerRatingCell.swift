//
//  playerRatingCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerRatingCell: UITableViewCell {
    
    var ratingNameLabel: UILabel!
    var ratingValueLabel: UILabel!
    var ratingBar: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Stat name label.
        self.ratingNameLabel = UILabel()
        self.ratingNameLabel.frame = CGRect(x: 20, y: 0, width: self.contentView.frame.width, height: 40)
        self.ratingNameLabel.textAlignment = .left
        self.ratingNameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightUltraLight)
        self.ratingNameLabel.textColor = UIColor.white
        self.ratingNameLabel.backgroundColor = UIColor.clear
        self.addSubview(self.ratingNameLabel)
        
        // Stat value label.
        self.ratingValueLabel = UILabel()
        self.ratingValueLabel.frame = CGRect(x: ((self.contentView.frame.width / 3) * 2), y: 0, width: (self.contentView.frame.width / 3) + 35, height: 40)
        self.ratingValueLabel.textAlignment = .right
        self.ratingValueLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
        self.ratingValueLabel.textColor = UIColor.white
        self.ratingValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.ratingValueLabel)
        
        // Stat bar.
        self.ratingBar = UIView()
        self.ratingBar.frame = CGRect(x: 20, y: 40, width: 355, height: 10)
        self.ratingBar.layer.cornerRadius = 5.0
        self.ratingBar.backgroundColor = UIColor.white
        self.addSubview(self.ratingBar)
        
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
