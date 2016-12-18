import UIKit
import BurstAPI
import AlamofireImage
import Unbox

let CollectionCoverPhotoHeight: CGFloat = 200
let CollectionSideSpacing: CGFloat = 10

class PhotoCollectionCollectionViewCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var collection: PhotoCollection? {
        didSet {
            guard let collection = collection else {
                return
            }
            configure(forCollection: collection)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .white
        countLabel.textColor = .white
        nameLabel.font = AppAppearance.regularFont(withSize: .collectionTitleSize, weight: .bold)
        countLabel.font = AppAppearance.regularFont(withSize: .cellText, weight: .medium)
        nameLabel.addShadow()
        countLabel.addShadow()
        layer.cornerRadius = 6
        imageViewHeightConstraint.constant = CollectionCoverPhotoHeight
        backgroundColor = AppAppearance.tableViewBackground
    }
    
    func configure(withAny any: Any) {
        guard let photoCollection = any as? PhotoCollection else {
            return
        }
        configure(forCollection: photoCollection)
    }
    
    private func configure(forCollection collection: PhotoCollection) {
        var contentString = "photos"
        countLabel.text = "\(collection.photosCount) \(contentString.modifiedPlural(forCount: collection.photosCount))"
        nameLabel.text = collection.title.uppercased()
        guard let coverPhoto = collection.coverPhoto else { return }
        imageView.backgroundColor = coverPhoto.color
        imageView.af_setImage(withURL: coverPhoto.url(forSize: .small),
                              imageTransition: .crossDissolve(1.0),
                              runImageTransitionIfCached: false)
    }

}
