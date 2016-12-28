import UIKit

class dividerCell: UITableViewCell {
    
    // Define the divider as an image view.
    var divider: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // Initiate cell.
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set the background colour to clear, and prevent the cell from being selected.
        backgroundColor = UIColor.clear
        selectionStyle = .none
  
        // Create the divider as an image view.
        self.divider = UIImageView(image: UIImage(named: "whiteLine.png"))
        // Set its size and add it to view.
        self.divider.frame = CGRect(x: 15, y: 10.0, width: UIScreen.main.bounds.width - 30, height: 0.5)
        self.addSubview(self.divider)
        
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
