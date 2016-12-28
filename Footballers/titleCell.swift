import UIKit

class titleCell: UITableViewCell {
    
    // Define the title label so that its text may be set.
    var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // Initiate cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set the background colour to clear.
        backgroundColor = UIColor.clear
        
        // Prevent the cell from being selected.
        selectionStyle = .none
        
        // Create the position label.
        self.titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.width - 30, height: 40))
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

