import UIKit

fileprivate let IconSize: CGFloat = 20

class PhotoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var labelSideConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setupDescription()
        setupButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.preferredMaxLayoutWidth =
            bounds.width - labelSideConstraint.constant * 2
    }
    
    private func setupButtons() {
        loveButton.setFAIcon(icon: .FAHeartO,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.white)
        
        saveButton.setFAIcon(icon: .FACloudDownload,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        saveButton.setFATitleColor(color: AppAppearance.white)
        
        addButton.setFAIcon(icon: .FAPlusCircle,
                            iconSize: AppAppearance.ButtonFAIconSize,
                            forState: .normal)
        addButton.setFATitleColor(color: AppAppearance.white)
    }
    
    private func setupDescription() {
        let attributedDescription = NSMutableAttributedString()
        
        let categoryFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAPictureO)
        let categoryAttributedString = AppAppearance.infoTextAttributedString(forValue: " dogs ")
        
        let sawFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAEye, textSize: 15)
        let sawAttributedString = AppAppearance.infoTextAttributedString(forValue: " 34555 ")
        
        let lovedFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAHeart)
        let lovedAttributedString = AppAppearance.infoTextAttributedString(forValue: " 21333 ")
        
        guard let category = categoryFAAttributedString,
            let saw = sawFAAttributedString,
            let loved = lovedFAAttributedString else {
            return
        }
        
        attributedDescription.append(category)
        attributedDescription.append(categoryAttributedString)
        
        attributedDescription.append(saw)
        attributedDescription.append(sawAttributedString)
        
        attributedDescription.append(loved)
        attributedDescription.append(lovedAttributedString)
        
        descriptionLabel.attributedText = attributedDescription
    }
    
}
