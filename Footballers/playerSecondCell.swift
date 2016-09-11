//
//  playerSecondCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 07/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerSecondCell: UITableViewCell {
    
    var heightValueLabel: UITextView!
    var heightLabel: UITextView!
    var numberValueLabel: UITextView!
    var numberLabel: UITextView!
    var weightValueLabel: UITextView!
    var weightLabel: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        // Height value label.
        self.heightValueLabel = UITextView()
        self.heightValueLabel.frame = CGRectMake(0, 0, self.contentView.frame.width / 3, 45)
        self.heightValueLabel.textAlignment = .Center
        self.heightValueLabel.font = UIFont.systemFontOfSize(35.0)
        self.heightValueLabel.textColor = UIColor.whiteColor()
        self.heightValueLabel.backgroundColor = UIColor.clearColor()
        self.heightValueLabel.scrollEnabled = false
        self.heightValueLabel.selectable = false
        self.contentView.addSubview(self.heightValueLabel)
        
        // Height label.
        self.heightLabel = UITextView()
        self.heightLabel.frame = CGRectMake(0, 45, self.contentView.frame.width / 3, 45)
        self.heightLabel.text = "Height (cm)"
        self.heightLabel.textAlignment = .Center
        self.heightLabel.font = UIFont.systemFontOfSize(13.0)
        self.heightLabel.textColor = UIColor.whiteColor()
        self.heightLabel.backgroundColor = UIColor.clearColor()
        self.heightLabel.scrollEnabled = false
        self.heightLabel.selectable = false
        self.addSubview(self.heightLabel)
        
        // Number value label.
        self.numberValueLabel = UITextView()
        self.numberValueLabel.frame = CGRectMake(self.contentView.frame.width / 3, 0, self.contentView.frame.width / 3, 45)
        self.numberValueLabel.textAlignment = .Center
        self.numberValueLabel.font = UIFont.systemFontOfSize(35.0)
        self.numberValueLabel.textColor = UIColor.whiteColor()
        self.numberValueLabel.backgroundColor = UIColor.clearColor()
        self.numberValueLabel.scrollEnabled = false
        self.numberValueLabel.selectable = false
        self.contentView.addSubview(self.numberValueLabel)
        
        // Number label.
        self.numberLabel = UITextView()
        self.numberLabel.frame = CGRectMake(self.contentView.frame.width / 3, 45, self.contentView.frame.width / 3, 45)
        self.numberLabel.text = "Shirt Number"
        self.numberLabel.textAlignment = .Center
        self.numberLabel.font = UIFont.systemFontOfSize(13.0)
        self.numberLabel.textColor = UIColor.whiteColor()
        self.numberLabel.backgroundColor = UIColor.clearColor()
        self.numberLabel.scrollEnabled = false
        self.numberLabel.selectable = false
        self.contentView.addSubview(self.numberLabel)
        
        // Weight value label.
        self.weightValueLabel = UITextView()
        self.weightValueLabel.frame = CGRectMake((self.contentView.frame.width / 3) * 2, 0, self.contentView.frame.width / 3, 45)
        self.weightValueLabel.textAlignment = .Center
        self.weightValueLabel.font = UIFont.systemFontOfSize(35.0)
        self.weightValueLabel.textColor = UIColor.whiteColor()
        self.weightValueLabel.backgroundColor = UIColor.clearColor()
        self.weightValueLabel.scrollEnabled = false
        self.weightValueLabel.selectable = false
        self.contentView.addSubview(self.weightValueLabel)
        
        // Weight label.
        self.weightLabel = UITextView()
        self.weightLabel.frame = CGRectMake((self.contentView.frame.width / 3) * 2, 45, self.contentView.frame.width / 3, 45)
        self.weightLabel.text = "Weight (kg)"
        self.weightLabel.textAlignment = .Center
        self.weightLabel.font = UIFont.systemFontOfSize(13.0)
        self.weightLabel.textColor = UIColor.whiteColor()
        self.weightLabel.backgroundColor = UIColor.clearColor()
        self.weightLabel.scrollEnabled = false
        self.weightLabel.selectable = false
        self.addSubview(self.weightLabel)
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
