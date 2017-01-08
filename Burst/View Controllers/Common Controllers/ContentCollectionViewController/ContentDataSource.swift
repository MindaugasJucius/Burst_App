import UIKit

private typealias KindConfiguration = (item: (Int) -> Any?, classes: [ContentCell.Type]?, defaultType: ContentCell.Type)

class ContentDataSource: NSObject, UICollectionViewDataSource {
    
    var objects: [Any]?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType: ContentCell.Type
        if let customType = cellClass(indexPath) {
            cellType = customType
        } else if cellClasses().count > indexPath.section {
            cellType = cellClasses()[indexPath.section]
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
    
}

extension ContentDataSource {

    func cellClasses() -> [ContentCell.Type] {
        return [DefaultContentCell.self]
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
        return objects?.count ?? 0
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    ///For each row in your list, override this to provide it with a specific item. Access this in your DatasourceCell by overriding datasourceItem.
    func item(_ indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
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
