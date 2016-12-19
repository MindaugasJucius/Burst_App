import BurstAPI

class PhotoCategoryCollectionViewCell: UICollectionViewCell, ReusableView {

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var categoryPhotosTeaserCollectionView: UICollectionView!
    @IBOutlet private weak var categoryPhotosCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(withAny any: Any) {
        guard let photoCategory = any as? PhotoCategory else {
            return
        }
        configure(forCategory: photoCategory)
    }
    
    func configure(forCategory category: PhotoCategory) {
        categoryNameLabel.text = category.categoryTitle
        categoryPhotosCountLabel.text = String(category.photoCount)
    }
}
