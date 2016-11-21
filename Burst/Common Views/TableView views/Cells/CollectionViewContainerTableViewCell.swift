import UIKit

class CollectionViewContainerTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
