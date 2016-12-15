import UIKit
import BurstAPI
import AlamofireImage

class PhotoHeader: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = AppAppearance.regularFont(withSize: .headerSubtitle)
        topLabel.textColor = AppAppearance.white
        bottomLabel.font = AppAppearance.regularFont(withSize: .cellText)
        bottomLabel.textColor = AppAppearance.white
        contentView.backgroundColor = .black
        contentView.add(borderTo: .top, width: 1, color: AppAppearance.lightBlack)
    }
    
    func setupInfo(forPhoto photo: Photo) {
        topLabel.text = photo.uploader.name
        let url = photo.uploader.userProfileImage.small
        imageView.af_setImage(withURL: url,
                              placeholderImage: #imageLiteral(resourceName: "Camera"),
                              filter: CircleFilter(),
                              imageTransition: .crossDissolve(1.0),
                              runImageTransitionIfCached: false)
        if let stats = photo.stats {
            setupDescription(forStats: stats)
        } else {
            let statsURL = String(format: BurstAPI.UnsplashPhotoStatsURL, photo.id)
            UnsplashGeneric.unsplash(
                getFromURL: URL(string: statsURL)!,
                success: { [weak self] (stats: Stats) in
                    self?.setupDescription(forStats: stats)
                    photo.stats = stats
                },
                failure: nil
            )
        }
    }
    
    private func setupDescription(forStats stats: Stats) {
        let description = NSMutableAttributedString()
        description.append(infoSubstring(withIcon: .FAHeart, infoText: "\(stats.likes)", withSeparator: true))
        description.append(infoSubstring(withIcon: .FACloudDownload, infoText: "\(stats.downloads)", withSeparator: true))
        description.append(infoSubstring(withIcon: .FAEye, infoText: "\(stats.views)"))
        bottomLabel.attributedText = description
    }
    
    private func infoSubstring(withIcon icon: FAType, infoText text: String, withSeparator separator: Bool = false) -> NSAttributedString {
        let attributedDescription = NSMutableAttributedString()
        let iconAttributedString = AppAppearance.faAttributedString(forIcon: icon,
            textSize: .iconSize,
            textColor: AppAppearance.subtitleColor)
        let fullText = separator ? " \(text)\(Separator)" : " \(text)"
        let attributedString = AppAppearance.infoTextAttributedString(forValue: fullText,
            textSize: .subtitleCellText,
            textColor: AppAppearance.subtitleColor)
        guard let iconString = iconAttributedString else {
            return attributedString
        }
        attributedDescription.append(iconString)
        attributedDescription.append(attributedString)
        return attributedDescription
    }
}
