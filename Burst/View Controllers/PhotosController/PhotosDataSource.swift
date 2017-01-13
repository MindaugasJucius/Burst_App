import BurstAPI

class PhotosDataSource: ContentDataSource<Photo> {
    
    private let dataController = PhotosDataController()
    private let photoURL: URL
    private let errorCallback: ErrorCallback
    
    init(photoURL: URL) {
        self.photoURL = photoURL
        self.errorCallback = { error in
            AlertControllerPresenterHelper.sharedInstance.topController(presentError: error)
        }
        super.init()
    }
    
    override func configureDataSource(forCollectionView collectionView: UICollectionView) {
        super.configureDataSource(forCollectionView: collectionView)
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.insert(photos: photos)
            },
            error: errorCallback
        )
    }
    
    override func handleRefresh(control: UIRefreshControl) {
        dataController.resetState()
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.insert(photos: photos)
                control.endRefreshing()
            },
            error: { [unowned self] error in
                self.errorCallback(error)
                control.endRefreshing()
            }
        )
    }
    
    override func handleInfiniteScroll(forCollectionView collectionView: UICollectionView) {
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.append(photos: photos)
                collectionView.finishInfiniteScroll()
            },
            error: { [unowned self] error in
                self.errorCallback(error)
                collectionView.finishInfiniteScroll()
            }
        )
    }
 
    override func cellClasses() -> [ContentCell.Type] {
        return [PhotoCell.self, EmptyStateCollectionViewCell.self]
    }
    
    override func referenceSize(forItemAtPath indexPath: IndexPath) -> CGSize {
        guard !objects.isEmpty else {
            return super.referenceSize(forItemAtPath: indexPath)
        }
        let photo = objects[indexPath.section]
        let rate = DefaultCellWidth / photo.fullSize.width
        let height = photo.fullSize.height * rate
        let size = CGSize(width: DefaultCellWidth, height: height)
        return size
    }
    
}
