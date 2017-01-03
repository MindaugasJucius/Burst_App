import UIKit

class PhotosTableHeaderView: UIView {
    
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = AppAppearance.lightBlack
        bottomLabel.textColor = AppAppearance.subtitleColor
        bottomLabel.font = AppAppearance.regularFont(withSize: .sectionHeaderTitle)
        bottomLabel.text = AppConstants.NewPhotosSubtitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLabel.preferredMaxLayoutWidth = bottomLabel.bounds.width
    }

}
