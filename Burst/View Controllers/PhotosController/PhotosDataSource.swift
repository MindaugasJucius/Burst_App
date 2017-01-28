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
                self.insert(newObjects: photos)
            },
            error: errorCallback
        )
    }
    
    override func handleRefresh(control: UIRefreshControl) {
        dataController.resetState()
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.insert(newObjects: photos)
                control.endRefreshing()
            },
            error: { [unowned self] error in
                self.errorCallback(error)
                control.endRefreshing()
            }
        )
    }
    
    override func footerItem(_ section: Int) -> Any? {
        var config = AllowedControlActions.defaultConfig
        config.append(.info)
        return config
    }
    
    override func handleInfiniteScroll(forCollectionView collectionView: UICollectionView) {
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.append(newObjects: photos)
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
    
    override func footerClasses() -> [ContentCell.Type]? {
        return [PhotoControlCollectionViewFooter.self]
    }
    
    override func headerClasses() -> [ContentCell.Type]? {
        return [DefaultHeader.self]
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
    
    override func referenceSize(forFooterInSection section: Int) -> CGSize {
        return CGSize(width: DefaultCellWidth, height: PhotoControlHeight)
    }
    
    override func referenceSize(forHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DefaultCellWidth, height: PhotoControlHeight)
    }
    
}
