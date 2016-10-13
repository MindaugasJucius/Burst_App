import UIKit

fileprivate let IconSize: CGFloat = 20

class PhotoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sawLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setupButtons()
        setupLikedLabel()
        setupSawLabel()
        setupCategoryLabel()
    }
    
    private func setupLikedLabel() {
        let attributedDescription = NSMutableAttributedString()
        let lovedFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAHeart)
        let lovedAttributedString = AppAppearance.infoTextAttributedString(forValue: " 21333")
        attributedDescription.append(lovedFAAttributedString!)
        attributedDescription.append(lovedAttributedString)
        likesLabel.attributedText = attributedDescription
    }
    
    private func setupSawLabel() {
        let attributedDescription = NSMutableAttributedString()
        
        let sawFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAEye, textSize: 15)
        let sawAttributedString = AppAppearance.infoTextAttributedString(forValue: " 34555")
        attributedDescription.append(sawFAAttributedString!)
        attributedDescription.append(sawAttributedString)
        sawLabel.attributedText = attributedDescription
    }
    
    private func setupCategoryLabel() {
        let attributedDescription = NSMutableAttributedString()
        
        let categoryFAAttributedString = AppAppearance.faAttributedString(forIcon: .FAPictureO)
        let categoryAttributedString = AppAppearance.infoTextAttributedString(forValue: " dogs")
        attributedDescription.append(categoryFAAttributedString!)
        attributedDescription.append(categoryAttributedString)
        categoryLabel.attributedText = attributedDescription
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
}
