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
    
    func configure(withUnboxable unboxable: Unboxable) {
        guard let photoCollection = unboxable as? PhotoCollection else { 
            return
        }
        configure(forCollection: photoCollection)
    }
    
    private func configure(forCollection collection: PhotoCollection) {
        countLabel.text = "\(collection.photosCount) photos"
        nameLabel.text = collection.title.uppercased()
        guard let coverPhoto = collection.coverPhoto else { return }
        imageView.backgroundColor = coverPhoto.color
        imageView.af_setImage(withURL: coverPhoto.urls.small,
                              imageTransition: .crossDissolve(1.0),
                              runImageTransitionIfCached: false)
    }

}
