import UIKit

class FullPhotoTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var topImageViewSpacingConstraing: NSLayoutConstraint!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    var topSpacing: CGFloat {
        set {
            topImageViewSpacingConstraing.constant = newValue
        }
        get {
            return topImageViewSpacingConstraing.constant
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFit
    }
    
}
