import UIKit

class PhotoHeader: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = AppAppearance.regularFont(withSize: .CellText)
        topLabel.textColor = AppAppearance.white
        setupPhotoDescription()
        contentView.backgroundColor = .black
    }
    
    private func setupPhotoDescription() {
        let description = NSMutableAttributedString()
        description.append(infoSubstring(withIcon: .FAHeart, infoText: "303030", withSeparator: true))
        description.append(infoSubstring(withIcon: .FACloudDownload, infoText: "303030", withSeparator: true))
        description.append(infoSubstring(withIcon: .FAPictureO, infoText: "dogze", withSeparator: true))
        description.append(infoSubstring(withIcon: .FAGlobe, infoText: "Vancouver, Canada"))
        bottomLabel.attributedText = description
    }
    
    private func infoSubstring(withIcon icon: FAType, infoText text: String, withSeparator separator: Bool = false) -> NSAttributedString {
        let attributedDescription = NSMutableAttributedString()
        let iconAttributedString = AppAppearance.faAttributedString(forIcon: icon,
            textSize: .IconSize,
            textColor: AppAppearance.subtitleColor)
        let fullText = separator ? " \(text)\(Separator)" : " \(text)"
        let attributedString = AppAppearance.infoTextAttributedString(forValue: fullText,
            textSize: .SubtitleCellText,
            textColor: AppAppearance.subtitleColor)
        guard let iconString = iconAttributedString else {
            return attributedString
        }
        attributedDescription.append(iconString)
        attributedDescription.append(attributedString)
        return attributedDescription
    }
}
