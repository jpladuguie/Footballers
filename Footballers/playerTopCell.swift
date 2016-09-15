//
//  playerTopCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 05/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerTopCell: UITableViewCell {
    
    var flagImage: UIImageView!
    var countryLabel: UITextView!
    var ageLabel: UITextView!
    var ageDescLabel: UITextView!
    var teamImage: UIImageView!
    var teamLabel: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: (self.contentView.frame.width / 6) - 17.25, y: 14.75, width: 34.5, height: 25.5)
        self.contentView.addSubview(flagImage)
        
        // Country label.
        self.countryLabel = UITextView()
        self.countryLabel.frame = CGRectMake(0, 45, self.contentView.frame.width / 3, 45)
        self.countryLabel.textAlignment = .Center
        self.countryLabel.font = UIFont.systemFontOfSize(13.0)
        self.countryLabel.textColor = UIColor.whiteColor()
        self.countryLabel.backgroundColor = UIColor.clearColor()
        self.countryLabel.scrollEnabled = false
        self.countryLabel.selectable = false
        self.addSubview(self.countryLabel)
        
        // Age label.
        self.ageLabel = UITextView()
        self.ageLabel.frame = CGRectMake(self.contentView.frame.width / 3, 0, self.contentView.frame.width / 3, 45)
        self.ageLabel.textAlignment = .Center
        self.ageLabel.font = UIFont.systemFontOfSize(35.0)
        self.ageLabel.textColor = UIColor.whiteColor()
        self.ageLabel.backgroundColor = UIColor.clearColor()
        self.ageLabel.scrollEnabled = false
        self.ageLabel.selectable = false
        self.contentView.addSubview(self.ageLabel)
     
        // Age description label.
        self.ageDescLabel = UITextView()
        self.ageDescLabel.frame = CGRectMake(self.contentView.frame.width / 3, 45, self.contentView.frame.width / 3, 30)
        self.ageDescLabel.text = "Age"
        self.ageDescLabel.textAlignment = .Center
        self.ageDescLabel.font = UIFont.systemFontOfSize(13.0)
        self.ageDescLabel.textColor = UIColor.whiteColor()
        self.ageDescLabel.backgroundColor = UIColor.clearColor()
        self.ageDescLabel.scrollEnabled = false
        self.ageDescLabel.selectable = false
        self.contentView.addSubview(self.ageDescLabel)
        
        // Team image.
        self.teamImage = UIImageView()
        self.teamImage.frame = CGRect(x: (self.contentView.frame.width * (5/6)) - 17.5, y: 10, width: 35, height: 35)
        self.contentView.addSubview(self.teamImage)
        
        // Team label.
        self.teamLabel = UITextView()
        self.teamLabel.frame = CGRectMake(((self.contentView.frame.width / 3) * 2), 45, self.contentView.frame.width / 3, 50)
        self.teamLabel.textAlignment = .Center
        self.teamLabel.font = UIFont.systemFontOfSize(13.0)
        self.teamLabel.textColor = UIColor.whiteColor()
        self.teamLabel.backgroundColor = UIColor.clearColor()
        self.teamLabel.scrollEnabled = false
        self.teamLabel.selectable = false
        self.contentView.addSubview(self.teamLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
