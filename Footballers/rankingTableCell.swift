//
//  rankingTableCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 21/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class rankingTableCell: UITableViewCell {

    var statNameLabel: UITextView!
    var statValueLabel: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        
        // Stat name label.
        self.statNameLabel = UITextView()
        self.statNameLabel.frame = CGRect(x: 100, y: 0, width: ((self.contentView.frame.width / 3) * 2) - 10, height: 40)
        self.statNameLabel.textAlignment = .left
        self.statNameLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.statNameLabel.textColor = UIColor.white
        self.statNameLabel.backgroundColor = UIColor.clear
        self.statNameLabel.isScrollEnabled = false
        self.statNameLabel.isSelectable = false
        self.addSubview(self.statNameLabel)
        
        // Stat value label.
        self.statValueLabel = UITextView()
        self.statValueLabel.frame = CGRect(x: ((self.contentView.frame.width / 3) * 2), y: 0, width: (self.contentView.frame.width / 3) + 45, height: 40)
        self.statValueLabel.textAlignment = .right
        self.statValueLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.statValueLabel.textColor = UIColor.white
        self.statValueLabel.backgroundColor = UIColor.clear
        self.statValueLabel.isScrollEnabled = false
        self.statValueLabel.isSelectable = false
        self.addSubview(self.statValueLabel)
        
        // Flag icon.
        
        

        
        
        
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
