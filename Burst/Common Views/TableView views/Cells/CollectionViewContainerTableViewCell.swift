import UIKit
import Unbox

typealias CellContentViewCallback = (UIView) -> ()

class CollectionViewContainerTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var customConfigCallback: CellContentViewCallback?

    var sectionItems: [SectionItem] = [] {
        didSet {
            guard !sectionItems.isEmpty else {
                return
            }
            registerCells()
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
    
    private func registerCells() {
        sectionItems.forEach { [weak self] sectionItem in
            let reusableViewTypeName = "\(sectionItem.cellItem)"
            let nib = UINib(nibName: reusableViewTypeName, bundle: nil)
            self?.collectionView.register(nib, forCellWithReuseIdentifier: reusableViewTypeName)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = AppAppearance.tableViewBackground
        backgroundColor = AppAppearance.tableViewBackground
    }
    
}

extension CollectionViewContainerTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension CollectionViewContainerTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionItems[section].representedObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(sectionItems[indexPath.section].cellItem)",
            for: indexPath
        )
        guard let reusableCell = cell as? ReusableView else {
            return cell
        }
        let representedObject = sectionItems[indexPath.section].representedObjects[indexPath.row]
        reusableCell.configure(withAny: representedObject)
        return cell
    }
    
}
