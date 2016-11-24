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
        layer.cornerRadius = 6
        imageViewHeightConstraint.constant = CollectionCoverPhotoHeight
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
        imageView.backgroundColor = collection.coverPhoto.color
        imageView.af_setImage(withURL: collection.coverPhoto.urls.small,
                              imageTransition: .crossDissolve(1.0),
                              runImageTransitionIfCached: false)
    }

}
