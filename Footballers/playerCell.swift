import UIKit

class playerCell: UITableViewCell {
    
    // Player/Stat name.
    var nameLabel: UILabel!
    
    // Stat value.
    var valueLabel: UILabel!
    
    // Position in the table.
    var positionLabel: UILabel!
    
    // Player's team.
    var teamLabel: UILabel!
    
    // Player's age.
    var ageLabel: UILabel!
    
    // Flag image of the player's country.
    var flagImage: UIImageView!
    
    // Player's image.
    var playerImage: UIImageView!
    
    // Rating bar.
    var ratingBar: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // Initiate cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set the background colour to clear.
        backgroundColor = UIColor.clear
        
        // Set the separator to have a 15 pixel margin.
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.layoutMargins = UIEdgeInsets.zero
        
        // Create name label.
        self.nameLabel = createLabel(frame: CGRect(x: 15, y: 0, width: ((UIScreen.main.bounds.width / 3) * 2), height: 40), textAlignment: .left, fontSize: 16.0, fontWeight: UIFontWeightLight)
        
        // Create value label.
        self.valueLabel = createLabel(frame: CGRect(x: ((UIScreen.main.bounds.width / 3) * 2), y: 0, width: (UIScreen.main.bounds.width / 3) - 15, height: 40), textAlignment: .right, fontSize: 16.0, fontWeight: UIFontWeightBold)
        
        // Create position label.
        self.positionLabel = createLabel(frame: CGRect(x: 15, y: 0, width: 30, height: 40), textAlignment: .right, fontSize: 16.0, fontWeight: UIFontWeightMedium)
        
        // Create team label.
        self.teamLabel = createLabel(frame: CGRect(x: 185, y: 40, width: 200, height: 30), textAlignment: .left, fontSize: 15.0, fontWeight: UIFontWeightLight)
        
        // Create age label.
        self.ageLabel = createLabel(frame: CGRect(x: 90, y: 40, width: 20, height: 30), textAlignment: .left, fontSize: 15.0, fontWeight: UIFontWeightLight)
       
        // Create flag image.
        self.flagImage = UIImageView(frame: CGRect(x: 50, y: 16.5, width: 23, height: 17))
        
        // Create player image.
        self.playerImage = UIImageView(frame: CGRect(x: 20, y: 4.5, width: 48.75, height: 67.5))
        
        // Create rating bar.
        self.ratingBar = UIView(frame: CGRect(x: 15, y: 40, width: 0, height: 10))
        self.ratingBar.layer.cornerRadius = 5.0
        
    }
    
    // Helper function to create a label given a frame, text alignment value, font size and weight.
    func createLabel(frame: CGRect, textAlignment: NSTextAlignment, fontSize: CGFloat, fontWeight: CGFloat) -> UILabel {
        
        // Define the label and set the attributes.
        let label = UILabel(frame: frame)
        label.textAlignment = textAlignment
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        
        // Return the label.
        return label
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
