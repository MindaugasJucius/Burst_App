import UIKit
import BurstAPI
import AlamofireImage

class PhotosTableViewDataSource: NSObject {
    
    private weak var tableView: UITableView!
    private weak var viewController: UIViewController!
    
    fileprivate var fetchedPhotos = [Photo]()

    private var currentPage = 1
    
    var onPhotoSave: PhotoCallback?
    
    init(tableView: UITableView, viewController: UIViewController) {
        self.tableView = tableView
        self.viewController = viewController
        super.init()
        registerViews()
        prepareForRetrieval()
        retrievePhotos()
    }
    
    private func registerViews() {
        let cellNib = UINib.init(nibName: PhotoTableViewCell.className(), bundle: nil)
        let headerNib = UINib.init(nibName: PhotoHeader.className(), bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: PhotoHeader.reuseIdentifier)
    }
    
    private func prepareForRetrieval() {
        tableView.addInfiniteScroll(handler: { [weak self] tableView in
                self?.retrievePhotos()
            }
        )
    }
    
    private func retrievePhotos() {
        UnsplashPhotos.photos(
            forPage: currentPage,
            success: { [weak self] photos in
                self?.updateThumbImages(forPhotos: photos)
            },
            failure: { [weak self] error in
                self?.presentError(error)
                self?.tableView.finishInfiniteScroll()
            }
        )
    }
    
    private func updateThumbImages(forPhotos photos: [Photo]) {
        let photoGroup = DispatchGroup()
        photos.forEach { photo in
            photoGroup.enter()
            UnsplashImages.image(
                fromUrl: photo.urls.small,
                withDownloader: UnsplashImages.thumbImageDownloader,
                progressHandler: nil,
                success: { image in
                    photo.thumbImage = image
                    photoGroup.leave()
                },
                failure: { [weak self] error in
                    self?.presentError(error)
                }
            )
        }
        photoGroup.notify(queue: DispatchQueue.main,
            execute: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateTableView(forPhotos: photos)
            }
        )
    }
    
    func updateTableView(forPhotos photos: [Photo]) {
        var indexPaths = [IndexPath]()
        let previousCount = fetchedPhotos.count
        var currentCount = previousCount
        // create index paths for affected items
        photos.forEach { _ in
            let indexPath = IndexPath(item: 0, section: currentCount)
            indexPaths.append(indexPath)
            currentCount = currentCount + 1
        }
        fetchedPhotos.append(contentsOf: photos)
        tableView.finishInfiniteScroll()
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integersIn: Range(uncheckedBounds: (lower: previousCount, upper: currentCount))), with: .fade)
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()

        currentPage = currentPage + 1
    }
    
    // MARK: - Helpers
    
    private func presentError(_ error: Error) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: viewController,
            withError: error
        )
    }
    
    private func photoCell(atPath indexPath: IndexPath) -> PhotoTableViewCell? {
        guard let cell = tableView.cellForRow(at: indexPath) as? PhotoTableViewCell else {
            return .none
        }
        return cell
    }
    
    // MARK: - Delegate helpers
    
    func downloadImagesForVisibleCells() {
        tableView.indexPathsForVisibleRows?.forEach{ [weak self] indexPath in
            guard let photo = self?.fetchedPhotos[indexPath.section],
                photo.smallImage == nil else {
                return
            }
            self?.image(forPhoto: photo, atPath: indexPath)
        }
    }
    
    func configureHeader(forView view: PhotoHeader, atSection section: Int) {
        let photo = fetchedPhotos[section]
        view.setupInfo(forPhoto: photo)
    }
    
    func height(forRowAtIndex rowIndex: Int) -> CGFloat {
        guard let image = fetchedPhotos[rowIndex].thumbImage else {
            return 0
        }
        let rate = (UIScreen.main.bounds.width - SideInset * 2) / image.size.width
        let height = image.size.height * rate
        return height + ControlHeight
    }
    
    // MARK: - Cell configuration
    
    private func image(forPhoto photo: Photo, atPath indexPath: IndexPath) {
        UnsplashImages.image(
            fromUrl: photo.urls.regular,
            withDownloader: UnsplashImages.cellImageDownloader,
            progressHandler: { [weak self] fractionCompleted in
                self?.photoCell(atPath: indexPath)?.downloadProgress = CGFloat(fractionCompleted)
            },
            success: { [weak self] image in
                self?.photoCell(atPath: indexPath)?.displayImage = image
            },
            failure: { [weak self] error in
                self?.presentError(error)
            }
        )
    }
    
    fileprivate func configure(photoCell: PhotoTableViewCell, forPhoto photo: Photo) {
        photoCell.configure(forPhoto: photo)
        photoCell.onSaveButton = { [weak self] photo in
            self?.onPhotoSave?(photo)
        }
    }
}

extension PhotosTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath)
        guard let photoTableViewCell = cell as? PhotoTableViewCell else {
            return cell
        }
        
        let photo = fetchedPhotos[indexPath.section]
        configure(photoCell: photoTableViewCell, forPhoto: photo)
        return photoTableViewCell
    }
}
