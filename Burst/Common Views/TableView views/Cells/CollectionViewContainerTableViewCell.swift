import UIKit
import Unbox

typealias CellContentViewCallback = (UIView) -> ()

class CollectionViewContainerTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    fileprivate var registeredCellReuseIdentifier: String = ""
    
    var customConfigCallback: CellContentViewCallback?

    var model: [Any] = [] {
        didSet {
            guard !model.isEmpty else {
                return
            }
            collectionView.reloadData()
        }
    }
    
    var isPagingEnabled: Bool {
        get {
            return collectionView.isPagingEnabled
        }
        set {
            collectionView.isPagingEnabled = newValue
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
    
    func cellToRegister(cell: UICollectionViewCell.Type, cellConfigurationCallback: CellContentViewCallback?) {
        let nib = UINib(nibName: cell.className, bundle: nil)
        customConfigCallback = cellConfigurationCallback
        collectionView.register(nib, forCellWithReuseIdentifier: cell.className)
        registeredCellReuseIdentifier = cell.className
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        customConfigCallback?(cell)
        guard let reusableCell = cell as? ReusableView else {
            return cell
        }
        reusableCell.configure(withAny: model[indexPath.row])
        return cell
    }
    
}
