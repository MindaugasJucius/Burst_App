import UIKit

class FullPhotoTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var topImageViewSpacingConstraing: NSLayoutConstraint!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var didTapClosePhotoPreview: (() -> ())?
    
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
        closeButton.addTarget(
            self,
            action: #selector(tappedClose(button:)),
            for: .touchUpInside
        )
        configureCloseButton()
    }
    
    @objc func tappedClose(button: UIButton) {
        didTapClosePhotoPreview?()
    }
    
    private func configureCloseButton() {
        closeButton.setFAIcon(icon: .FAClose,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        closeButton.setFATitleColor(color: AppAppearance.white)
    }
}
