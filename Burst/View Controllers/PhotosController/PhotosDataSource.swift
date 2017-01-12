import BurstAPI

class PhotosDataSource: ContentDataSource<Photo> {
    
    private let dataController = PhotosDataController()
    
    private let photoURL: URL
    
    init(photoURL: URL) {
        self.photoURL = photoURL
        super.init()
    }
    
    override func configureDataSource(forCollectionView collectionView: UICollectionView) {
        super.configureDataSource(forCollectionView: collectionView)
        dataController.fetchPhotos(
            fromURL: photoURL,
            success: { [unowned self] (photos: [Photo]) in
                self.objects = photos
            },
            error: { error in
                
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
        let photo = objects[indexPath.row]
        let rate = DefaultCellWidth / photo.fullSize.width
        let height = photo.fullSize.height * rate
        let size = CGSize(width: DefaultCellWidth, height: height)
        return size
    }
    
}
