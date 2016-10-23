//
//  rankingTableCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 21/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class rankingTableCell: UITableViewCell {

    var rankingLabel: UILabel!
    var flagImage: UIImageView!
    var statNameLabel: UILabel!
    var statValueLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .gray
        
        // Ranking label.
        self.rankingLabel = UILabel()
        self.rankingLabel.frame = CGRect(x: 20, y: 0, width: 30, height: 40)
        self.rankingLabel.textAlignment = .right
        self.rankingLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.rankingLabel.textColor = UIColor.white
        self.rankingLabel.backgroundColor = UIColor.clear
        self.addSubview(self.rankingLabel)
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: 60, y: 11.5, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Stat name label.
        self.statNameLabel = UILabel()
        self.statNameLabel.frame = CGRect(x: 95, y: 0, width: self.contentView.frame.width, height: 40)
        self.statNameLabel.textAlignment = .left
        self.statNameLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.statNameLabel.textColor = UIColor.white
        self.statNameLabel.backgroundColor = UIColor.clear
        self.addSubview(self.statNameLabel)
        
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
