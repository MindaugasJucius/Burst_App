import UIKit
import Unbox

class CollectionViewContainerTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    fileprivate var registeredCellReuseIdentifier: String = ""
    
    var model: [Unboxable] = [] {
        didSet {
            guard !model.isEmpty else {
                return
            }
            collectionView.reloadData()
        }
    }
    
    var layout: UICollectionViewLayout {
        get {
            return collectionView.collectionViewLayout
        }
        set {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.collectionViewLayout = newValue
        }
    }
    
    func cellToRegister(cell: UICollectionViewCell.Type) {
        let nib = UINib(nibName: cell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cell.className)
        registeredCellReuseIdentifier = cell.className
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = AppAppearance.tableViewBackground
        backgroundColor = AppAppearance.tableViewBackground
    }
    
}

extension CollectionViewContainerTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: registeredCellReuseIdentifier, for: indexPath)
        guard let reusableCell = cell as? ReusableView else {
            return cell
        }
        reusableCell.configure(withUnboxable: model[indexPath.row])
        return cell
    }
    
}
