import UIKit
import BurstAPI
import AlamofireImage

class PhotoCollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
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
