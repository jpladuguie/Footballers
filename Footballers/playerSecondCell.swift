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
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Height value label.
        self.heightValueLabel = UITextView()
        self.heightValueLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: 45)
        self.heightValueLabel.textAlignment = .center
        self.heightValueLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.heightValueLabel.textColor = UIColor.white
        self.heightValueLabel.backgroundColor = UIColor.clear
        self.heightValueLabel.isScrollEnabled = false
        self.heightValueLabel.isSelectable = false
        self.contentView.addSubview(self.heightValueLabel)
        
        // Height label.
        self.heightLabel = UITextView()
        self.heightLabel.frame = CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width / 3, height: 45)
        self.heightLabel.text = "Height (cm)"
        self.heightLabel.textAlignment = .center
        self.heightLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        self.heightLabel.textColor = UIColor.white
        self.heightLabel.backgroundColor = UIColor.clear
        self.heightLabel.isScrollEnabled = false
        self.heightLabel.isSelectable = false
        self.addSubview(self.heightLabel)
        
        // Number value label.
        self.numberValueLabel = UITextView()
        self.numberValueLabel.frame = CGRect(x: UIScreen.main.bounds.width / 3, y: 0, width: UIScreen.main.bounds.width / 3, height: 45)
        self.numberValueLabel.textAlignment = .center
        self.numberValueLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.numberValueLabel.textColor = UIColor.white
        self.numberValueLabel.backgroundColor = UIColor.clear
        self.numberValueLabel.isScrollEnabled = false
        self.numberValueLabel.isSelectable = false
        self.contentView.addSubview(self.numberValueLabel)
        
        // Number label.
        self.numberLabel = UITextView()
        self.numberLabel.frame = CGRect(x: UIScreen.main.bounds.width / 3, y: 45, width: UIScreen.main.bounds.width / 3, height: 45)
        self.numberLabel.text = "Shirt Number"
        self.numberLabel.textAlignment = .center
        self.numberLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        self.numberLabel.textColor = UIColor.white
        self.numberLabel.backgroundColor = UIColor.clear
        self.numberLabel.isScrollEnabled = false
        self.numberLabel.isSelectable = false
        self.contentView.addSubview(self.numberLabel)
        
        // Weight value label.
        self.weightValueLabel = UITextView()
        self.weightValueLabel.frame = CGRect(x: (UIScreen.main.bounds.width * 2) / 3, y: 0, width: UIScreen.main.bounds.width / 3, height: 45)
        self.weightValueLabel.textAlignment = .center
        self.weightValueLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.weightValueLabel.textColor = UIColor.white
        self.weightValueLabel.backgroundColor = UIColor.clear
        self.weightValueLabel.isScrollEnabled = false
        self.weightValueLabel.isSelectable = false
        self.contentView.addSubview(self.weightValueLabel)
        
        // Weight label.
        self.weightLabel = UITextView()
        self.weightLabel.frame = CGRect(x: (UIScreen.main.bounds.width * 2) / 3, y: 45, width: UIScreen.main.bounds.width / 3, height: 45)
        self.weightLabel.text = "Weight (kg)"
        self.weightLabel.textAlignment = .center
        self.weightLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightLight)
        self.weightLabel.textColor = UIColor.white
        self.weightLabel.backgroundColor = UIColor.clear
        self.weightLabel.isScrollEnabled = false
        self.weightLabel.isSelectable = false
        self.addSubview(self.weightLabel)
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
