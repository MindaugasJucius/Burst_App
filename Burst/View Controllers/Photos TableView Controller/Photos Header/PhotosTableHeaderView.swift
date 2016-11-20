import UIKit

class PhotosTableHeaderView: UIView {
    
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLabel.textColor = AppAppearance.subtitleColor
        bottomLabel.font = AppAppearance.condensedFont(withSize: .headerSubtitle)
        topLabel.textColor = AppAppearance.white
        topLabel.font = AppAppearance.condensedFont(withSize: .headerTitle)
        topLabel.text = NewPhotosTitle.uppercased()
        bottomLabel.text = NewPhotosSubtitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLabel.preferredMaxLayoutWidth = topLabel.bounds.width
        bottomLabel.preferredMaxLayoutWidth = bottomLabel.bounds.width
    }

}
