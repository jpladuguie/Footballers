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
        backgroundColor = UIColor.clear
        self.contentView.frame = self.bounds
        print(self.contentView.frame)
        selectionStyle = .none
        
        // Flag image.
        self.flagImage = UIImageView()
        self.flagImage.frame = CGRect(x: (self.contentView.frame.width / 6) - 17.25, y: 14.75, width: 34.5, height: 25.5)
        self.contentView.addSubview(flagImage)
        
        // Country label.
        self.countryLabel = UITextView()
        self.countryLabel.frame = CGRect(x: 0, y: 45, width: self.contentView.frame.width / 3, height: 45)
        self.countryLabel.textAlignment = .center
        self.countryLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.countryLabel.textColor = UIColor.white
        self.countryLabel.backgroundColor = UIColor.clear
        self.countryLabel.isScrollEnabled = false
        self.countryLabel.isSelectable = false
        self.addSubview(self.countryLabel)
        
        // Age label.
        self.ageLabel = UITextView()
        self.ageLabel.frame = CGRect(x: self.contentView.frame.width / 3, y: 0, width: self.contentView.frame.width / 3, height: 45)
        self.ageLabel.textAlignment = .center
        self.ageLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.ageLabel.textColor = UIColor.white
        self.ageLabel.backgroundColor = UIColor.clear
        self.ageLabel.isScrollEnabled = false
        self.ageLabel.isSelectable = false
        self.contentView.addSubview(self.ageLabel)
     
        // Age description label.
        self.ageDescLabel = UITextView()
        self.ageDescLabel.frame = CGRect(x: self.contentView.frame.width / 3, y: 45, width: self.contentView.frame.width / 3, height: 30)
        self.ageDescLabel.text = "Age"
        self.ageDescLabel.textAlignment = .center
        self.ageDescLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.ageDescLabel.textColor = UIColor.white
        self.ageDescLabel.backgroundColor = UIColor.clear
        self.ageDescLabel.isScrollEnabled = false
        self.ageDescLabel.isSelectable = false
        self.contentView.addSubview(self.ageDescLabel)
        
        // Team image.
        self.teamImage = UIImageView()
        self.teamImage.frame = CGRect(x: (self.contentView.frame.width * (5/6)) - 17.5, y: 10, width: 35, height: 35)
        self.contentView.addSubview(self.teamImage)
        
        // Team label.
        self.teamLabel = UITextView()
        self.teamLabel.frame = CGRect(x: ((self.contentView.frame.width / 3) * 2), y: 45, width: self.contentView.frame.width / 3, height: 50)
        self.teamLabel.textAlignment = .center
        self.teamLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.teamLabel.textColor = UIColor.white
        self.teamLabel.backgroundColor = UIColor.clear
        self.teamLabel.isScrollEnabled = false
        self.teamLabel.isSelectable = false
        self.contentView.addSubview(self.teamLabel)
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
