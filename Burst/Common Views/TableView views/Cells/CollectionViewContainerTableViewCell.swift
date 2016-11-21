import UIKit
import Unbox

class CollectionViewContainerTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var model: [Unboxable] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
