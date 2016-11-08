//
//  playerTitleCell.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class playerTitleCell: UITableViewCell {
    
    var title: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Stat name label.
        /*self.title = UILabel()
        self.title.frame = CGRect(x: 20, y: 0, width: self.contentView.frame.width, height: 40)
        self.title.textAlignment = .left
        self.title.font = UIFont.systemFont(ofSize: 32.0)
        self.title.textColor = UIColor.white
        self.title.backgroundColor = UIColor.clear
        self.addSubview(self.title)*/
        
        // Create the divider.
        let divider = UIImageView(image: UIImage(named: "whiteLine.png"))
        // Set its size and add it to view.
        //divider.frame = CGRect(x: 20.0, y: 45.0, width: 335, height: 1.0)
        divider.frame = CGRect(x: 20.0, y: 10.0, width: 335, height: 1.0)
        self.addSubview(divider)
        
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
