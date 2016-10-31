import UIKit
import BurstAPI
import AlamofireImage

class PhotoHeader: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = AppAppearance.regularFont(withSize: .CellText)
        topLabel.textColor = AppAppearance.white
        bottomLabel.font = AppAppearance.regularFont(withSize: .CellText)
        bottomLabel.textColor = AppAppearance.white
        contentView.backgroundColor = .black
    }
    
    func setupInfo(forPhoto photo: Photo) {
        topLabel.text = photo.uploader.name
        let url = URL(string: photo.uploader.userProfileImage.small)!
        imageView.af_setImage(withURL: url,
                              placeholderImage: #imageLiteral(resourceName: "Camera"),
                              filter: CircleFilter(),
                              imageTransition: .crossDissolve(1.0),
                              runImageTransitionIfCached: false)
        UnsplashPhotoStats.stats(forPhoto: photo,
            completion: { [weak self] stats, error in
                photo.stats = stats
                self?.setupDescription(forPhoto: photo)
            }
        )
    }
    
    private func setupDescription(forPhoto photo: Photo) {
        guard let stats = photo.stats else {
            return
        }
        let description = NSMutableAttributedString()
        description.append(infoSubstring(withIcon: .FAHeart, infoText: "\(stats.likes)", withSeparator: true))
        description.append(infoSubstring(withIcon: .FACloudDownload, infoText: "\(stats.downloads)", withSeparator: true))
        description.append(infoSubstring(withIcon: .FAEye, infoText: "\(stats.views)"))
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
