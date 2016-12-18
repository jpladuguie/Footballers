//
//  titleCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit

class titleCell: UITableViewCell {
    
    // Position in the table.
    var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Position label.
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRect(x: 20, y: 0, width: self.frame.width - 40, height: 40)
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.backgroundColor = UIColor.clear
        self.addSubview(self.titleLabel)
        
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

