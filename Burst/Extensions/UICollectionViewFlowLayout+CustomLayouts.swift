fileprivate let SideInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
fileprivate let CollectionSideSpacing: CGFloat = 10
fileprivate let CoverPhotoSideSpacing: CGFloat = 30

let CollectionCoverPhotoHeight: CGFloat = 200
let PhotoHeight: CGFloat = 100

extension UICollectionViewFlowLayout {

    static func photoCollectionsLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CoverPhotoSideSpacing
        flowLayout.sectionInset = SideInset
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width-CoverPhotoSideSpacing,
            height: CollectionCoverPhotoHeight
        )
        return flowLayout
    }
    
    static func photoCollectionLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CollectionSideSpacing
        flowLayout.sectionInset = SideInset
        flowLayout.itemSize = CGSize(
            width: PhotoHeight,
            height: PhotoHeight
        )
        return flowLayout
    }
}
