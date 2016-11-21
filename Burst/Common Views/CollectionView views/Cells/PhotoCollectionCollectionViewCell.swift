import UIKit

class PhotoCollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.text = "230 photos"
        nameLabel.text = "Collection #24Coll ection #24 Coll ection".uppercased()
        nameLabel.textColor = .white
    }

}
