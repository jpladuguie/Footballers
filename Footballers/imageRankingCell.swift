import UIKit

class imageRankingCell: playerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .gray
        
        // Flag image.
        self.flagImage.frame = CGRect(x: 85, y: 55, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Name label.
        self.nameLabel.frame = CGRect(x: 85, y: 0, width: self.contentView.frame.width - 105, height: 40)
        self.nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        self.contentView.addSubview(self.nameLabel)
       
        // Team label.
        self.teamLabel.frame = CGRect(x: 85, y: 25, width: self.contentView.frame.width - 105, height: 30)
        self.contentView.addSubview(self.teamLabel)

        // Profile image.
        self.contentView.addSubview(self.playerImage)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
