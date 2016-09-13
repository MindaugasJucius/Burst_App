import UIKit
import BurstAPI

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: PhotosControllerDataSource?
    private var blurredCell: PhotoCellCollectionViewCell?
    
    var delegate: ContainerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        collectionView.infiniteScrollIndicatorStyle = .Gray
        dataSource = PhotosControllerDataSource(collectionView: collectionView, viewController: self)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        addTapGesture()
    }
    
    @objc private func tap(gesture: UITapGestureRecognizer) {
        dataSource?.clearCellBlur()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dataSource?.clearCellBlur()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Delegate
    
    func downloadPhoto(photo: Photo) {
        delegate?.downloadPhoto(photo)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension PhotosCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let dataSource = dataSource else { return CGSizeZero }
        let imageSize = dataSource.collectionViewItemSizeAtIndexPath(indexPath)
        
        return CGSizeMake(imageSize.width, imageSize.height)
    }

}
