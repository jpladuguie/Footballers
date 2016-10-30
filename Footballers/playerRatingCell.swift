//
//  playerRatingCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerRatingCell: UITableViewCell {
    
    var statNameLabel: UILabel!
    var statValueLabel: UILabel!
    var statBar: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Stat name label.
        self.statNameLabel = UILabel()
        self.statNameLabel.frame = CGRect(x: 20, y: 0, width: self.contentView.frame.width, height: 40)
        self.statNameLabel.textAlignment = .left
        self.statNameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: -1.0)
        self.statNameLabel.textColor = UIColor.white
        self.statNameLabel.backgroundColor = UIColor.clear
        self.addSubview(self.statNameLabel)
        
        // Stat value label.
        self.statValueLabel = UILabel()
        self.statValueLabel.frame = CGRect(x: ((self.contentView.frame.width / 3) * 2), y: 0, width: (self.contentView.frame.width / 3) + 35, height: 40)
        self.statValueLabel.textAlignment = .right
        self.statValueLabel.font = UIFont.systemFont(ofSize: 16.0, weight: 0.4)
        self.statValueLabel.textColor = UIColor.white
        self.statValueLabel.backgroundColor = UIColor.clear
        self.addSubview(self.statValueLabel)
        
        // Stat bar.
        self.statBar = UIView()
        self.statBar.frame = CGRect(x: 20, y: 40, width: 355, height: 10)
        self.statBar.layer.cornerRadius = 5.0
        self.statBar.backgroundColor = UIColor.white
        self.addSubview(self.statBar)
        
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
