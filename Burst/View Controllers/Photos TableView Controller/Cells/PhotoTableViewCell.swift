import UIKit
import BurstAPI

fileprivate let IconSize: CGFloat = 20

typealias PhotoCallback = (_ photo: Photo?) -> ()

class PhotoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var onLoveButton: PhotoCallback?
    var onAddButton: PhotoCallback?
    var onSaveButton: PhotoCallback?
    
    private var displayPhoto: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setupButtons()
    }
    
    func configure(forPhoto photo: Photo) {
        displayPhoto = photo
        photoImageView.image = photo.thumbImage
        guard let image = photo.thumbImage else {
            return
        }
        let aspectRatio = image.size.width / image.size.height
        let aspectRatioConstraint = NSLayoutConstraint(item: photoImageView, attribute: .width, relatedBy: .equal, toItem: photoImageView, attribute: .height, multiplier: aspectRatio, constant: 0.0)
        aspectRatioConstraint.priority = 999
        photoImageView.addConstraint(aspectRatioConstraint)
    }
    
    @IBAction func loveButtonTouched(_ sender: UIButton) {
        loveButton.setFAIcon(icon: .FAHeart,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.darkRed)
        onLoveButton?(displayPhoto)
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        onSaveButton?(displayPhoto)
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        onAddButton?(displayPhoto)
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
    
    override func prepareForReuse() {
        photoImageView?.image = nil
        loveButton.setFAIcon(icon: .FAHeartO,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.white)
    }
}
