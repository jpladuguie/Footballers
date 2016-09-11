//
//  playerStatCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 07/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerStatCell: UITableViewCell {
    
    var statNameLabel: UITextView!
    var statValueLabel: UITextView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        // Stat name label.
        self.statNameLabel = UITextView()
        self.statNameLabel.frame = CGRectMake(10, 0, ((self.contentView.frame.width / 3) * 2) - 10, 40)
        self.statNameLabel.textAlignment = .Left
        self.statNameLabel.font = UIFont.systemFontOfSize(15.0)
        self.statNameLabel.textColor = UIColor.whiteColor()
        self.statNameLabel.backgroundColor = UIColor.clearColor()
        self.statNameLabel.scrollEnabled = false
        self.statNameLabel.selectable = false
        self.addSubview(self.statNameLabel)
        
        // Stat value label.
        self.statValueLabel = UITextView()
        self.statValueLabel.frame = CGRectMake(((self.contentView.frame.width / 3) * 2), 0, (self.contentView.frame.width / 3) - 10, 40)
        self.statValueLabel.textAlignment = .Right
        self.statValueLabel.font = UIFont.boldSystemFontOfSize(15.0)
        self.statValueLabel.textColor = UIColor.whiteColor()
        self.statValueLabel.backgroundColor = UIColor.clearColor()
        self.statValueLabel.scrollEnabled = false
        self.statValueLabel.selectable = false
        self.addSubview(self.statValueLabel)
        
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
