import UIKit

let DefaultCellHeight: CGFloat = 50
let DefaultCellWidth: CGFloat = UIScreen.main.bounds.width

private typealias KindConfiguration = (item: (Int) -> Any?, classes: [ContentCell.Type]?, defaultType: ContentCell.Type)

class ContentDataSource<U>: NSObject, UICollectionViewDataSource {
    
    var objects: [U] = []
    
    weak var collectionView: UICollectionView?
    
    func configureDataSource(forCollectionView collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func handleRefresh(control: UIRefreshControl) {
        control.endRefreshing()
        collectionView?.reloadData()
    }
    
    func handleInfiniteScroll(forCollectionView collectionView: UICollectionView) {
        collectionView.finishInfiniteScroll()
    }
    
    // MARK: - Helpers
    
    private func configuration(forKind kind: String) -> KindConfiguration? {
        switch kind {
        case UICollectionElementKindSectionFooter:
            return (footerItem, footerClasses(), DefaultFooter.self)
        case UICollectionElementKindSectionHeader:
            return (headerItem, headerClasses(), DefaultHeader.self)
        default:
            return nil
        }
    }
    
    func append(photos: [U]) {
        
        let allItemsCount = objects.count + photos.count
        let currentIndexSet = indexSet(
            startingFrom: objects.count,
            to: allItemsCount
        )
        
        objects.append(contentsOf: photos)
        
        collectionView?.performBatchUpdates(
            { [unowned self] in
                self.collectionView?.insertSections(currentIndexSet)
            },
            completion: nil
        )
    }
    
    func insert(photos: [U]) {
        let sectionCount = objects.isEmpty ? 1 : objects.count
        let previousIndexSet = indexSet(startingFrom: 0, to: sectionCount)
        objects = photos
        let currentIndexSet = indexSet(startingFrom: 0, to: objects.count)
        collectionView?.performBatchUpdates(
            { [unowned self] in
                self.collectionView?.deleteSections(previousIndexSet)
                self.collectionView?.insertSections(currentIndexSet)
            },
            completion: nil
        )
    }
    
    private func indexSet(startingFrom: Int, to: Int) -> IndexSet {
        let range = Range(uncheckedBounds: (lower: startingFrom, upper: to))
        return IndexSet(integersIn: range)
    }
    
    // BUG - SR-857 https://bugs.swift.org/browse/SR-857
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: ContentCell.Type
        
        guard !objects.isEmpty else {
            let emptyStateCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCollectionViewCell.className, for: indexPath) as! EmptyStateCollectionViewCell
            emptyStateCell.emptyStateViewType = .none
            return emptyStateCell
        }
        
        if let customType = cellClass(indexPath) {
            cellType = customType
        } else if let cellClass = cellClasses().first {
            cellType = cellClass
        } else {
            cellType = DefaultContentCell.self
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.className, for: indexPath)
        guard let contentCell = cell as? ContentCell else {
            return cell
        }
        contentCell.dataSourceItem = item(indexPath)
        return contentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let configurationForKind = configuration(forKind: kind) else {
            return UICollectionReusableView()
        }
        let supplementaryElementType: ContentCell.Type
        
        if let classes = configurationForKind.classes, classes.count > indexPath.section {
            supplementaryElementType = classes[indexPath.section]
        } else if let elementClass = configurationForKind.classes?.first {
            supplementaryElementType = elementClass
        } else {
            supplementaryElementType = configurationForKind.defaultType
        }
        
        let supplementaryElement = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryElementType.className, for: indexPath)
        
        guard let reusableView = supplementaryElement as? ContentCell else {
            return supplementaryElement
        }
        
        reusableView.dataSourceItem = configurationForKind.item(indexPath.section)
        return reusableView
    }
    
    
    // MARK: - Delegate size helpers
    
    func referenceSize(forHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func referenceSize(forFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func referenceSize(forItemAtPath indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize(width: DefaultCellWidth, height: DefaultCellHeight)
        if objects.isEmpty {
            guard let height = collectionView?.bounds.height else {
                return itemSize
            }
            itemSize.height = height
            return itemSize
        } else {
            return itemSize
        }
    }
    
    // MARK: - Overriding points for data source customization
    
    func cellClasses() -> [ContentCell.Type] {
        return [DefaultContentCell.self, EmptyStateCollectionViewCell.self]
    }
    
    ///If you want more fine tuned control per row, override this method to provide the proper cell type that should be rendered
    func cellClass(_ indexPath: IndexPath) -> ContentCell.Type? {
        return nil
    }
    
    ///Override this method to provide your list with what kind of headers should be rendered per section
    func headerClasses() -> [ContentCell.Type]? {
        return [DefaultHeader.self]
    }
    
    ///Override this method to provide your list with what kind of footers should be rendered per section
    func footerClasses() -> [ContentCell.Type]? {
        return [DefaultFooter.self]
    }
    
    func numberOfItems(_ section: Int) -> Int {
        return 1
    }
    
    func numberOfSections() -> Int {
        return objects.isEmpty ? 1 : objects.count
    }
    
    ///For each row in your list, override this to provide it with a specific item. Access this in your DatasourceCell by overriding datasourceItem.
    func item(_ indexPath: IndexPath) -> Any? {
        return objects[indexPath.section]
    }
    
    ///If your headers need a special item, return it here.
    func headerItem(_ section: Int) -> Any? {
        return nil
    }
    
    ///If your footers need a special item, return it here
    func footerItem(_ section: Int) -> Any? {
        return nil
    }
    
}
