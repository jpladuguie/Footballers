import UIKit

class detailedRankingCell: playerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // Set up the cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .gray
        
        // Position label.
        self.positionLabel.frame = CGRect(x: 10, y: 5, width: 30, height: 40)
        self.contentView.addSubview(self.positionLabel)
        
        // Flag image.
        self.flagImage.frame = CGRect(x: 50, y: 16.5, width: 23, height: 17)
        self.contentView.addSubview(flagImage)
        
        // Name label.
        self.nameLabel.frame = CGRect(x: 90, y: 5, width: UIScreen.main.bounds.width - 70, height: 40)
        self.nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        self.contentView.addSubview(self.nameLabel)
        
        // Stat value label.
        self.valueLabel.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 5, width: 50, height: 40)
        self.contentView.addSubview(self.valueLabel)
        
        // Age label
        let age = createLabel(frame: CGRect(x: 50, y: 40, width: 40, height: 30), textAlignment: .left, fontSize: 15.0, fontWeight: UIFontWeightMedium)
        age.text = "Age"
        self.contentView.addSubview(age)
        
        // Age label.
        self.contentView.addSubview(self.ageLabel)
        
        // Name label.
        let team = createLabel(frame: CGRect(x: 130, y: 40, width: 50, height: 30), textAlignment: .left, fontSize: 15.0, fontWeight: UIFontWeightMedium)
        team.text = "Team"
        self.contentView.addSubview(team)
        
        // Name label.
        self.contentView.addSubview(self.teamLabel)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
