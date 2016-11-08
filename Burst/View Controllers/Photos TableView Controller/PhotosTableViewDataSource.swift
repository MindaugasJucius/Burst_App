import UIKit
import BurstAPI
import AlamofireImage

private let InitialPageIndex = 1

let PeparationNotificationName = Notification.Name("PreparationNotification")

class PhotosTableViewDataSource: NSObject {
    
    private var currentPage = InitialPageIndex
    private var prepared = false
    private weak var tableView: UITableView!
    
    fileprivate weak var container: StatefulContainerView!
    fileprivate var fetchedPhotos = [Photo]()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(withRefreshControl:)), for: .valueChanged)
        return refreshControl
    }()
    
    var onPhotoSave: PhotoCallback?
    
    init(tableView: UITableView, container: StatefulContainerView) {
        self.tableView = tableView
        self.container = container
        super.init()
        registerViews()
        prepareForRetrieval()
        retrievePhotos()
    }
    
    private func registerViews() {
        let cellNib = UINib.init(nibName: PhotoTableViewCell.className, bundle: nil)
        let emptyStateCellNib = UINib.init(nibName: EmptyStateTableViewCell.className, bundle: nil)
        let headerNib = UINib.init(nibName: PhotoHeader.className, bundle: nil)
        
        tableView.register(emptyStateCellNib, forCellReuseIdentifier: EmptyStateTableViewCell.reuseIdentifier)
        tableView.register(cellNib, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: PhotoHeader.reuseIdentifier)
    }
    
    private func prepareForRetrieval() {
        tableView.addInfiniteScroll(handler: { [weak self] tableView in
                self?.retrievePhotos()
            }
        )
        tableView.setShouldShowInfiniteScrollHandler { [weak self] tableView in
            guard let strongSelf = self else {
                return false
            }
            return !strongSelf.container.emptyState
        }
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(withRefreshControl refreshControl: UIRefreshControl) {
        guard !tableView.isAnimatingInfiniteScroll else {
            refreshControl.endRefreshing()
            return
        }
        let range = Range(uncheckedBounds: (lower: 0, upper: fetchedPhotos.count))
        let sectionsToDeleteIndexSet = IndexSet(integersIn: range)
        currentPage = InitialPageIndex
        fetchedPhotos = []
        tableView.deleteSections(sectionsToDeleteIndexSet, with: .fade)
        retrievePhotos()
    }
    
    private func postPreparedNotificationIfNeeded() {
        guard !prepared else {
            return
        }
        prepared = true
        NotificationCenter.default.post(name: PeparationNotificationName, object: nil)
    }
    
    private func retrievePhotos() {
        UnsplashPhotos.photos(
            forPage: currentPage,
            success: { [weak self] photos in
                let state: ContainerViewState = photos.isEmpty ? .empty : .normal
                self?.stateChangeHandler(state: state)
                self?.updateThumbImages(forPhotos: photos)
            },
            failure: { [weak self] error in
                let state: ContainerViewState = self?.currentPage == InitialPageIndex ? .empty : .normal
                self?.stateChangeHandler(state: state)
                self?.container.handle(error: error)
                self?.refreshControl.endRefreshing()
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
                    self?.container.handle(error: error)
                }
            )
        }
        photoGroup.notify(queue: DispatchQueue.main,
            execute: { [weak self] in
                self?.updateTableView(forPhotos: photos)
            }
        )
    }
    
    private func updateTableView(forPhotos photos: [Photo]) {
        guard !photos.isEmpty else {
            return
        }
        var indexPaths = [IndexPath]()
        let previousCount = fetchedPhotos.count
        var currentCount = previousCount
        
        photos.forEach { _ in
            let indexPath = IndexPath(item: 0, section: currentCount)
            indexPaths.append(indexPath)
            currentCount = currentCount + 1
        }
        let sectionRange = Range(uncheckedBounds: (lower: previousCount, upper: currentCount))
        let indexSet = IndexSet(integersIn: sectionRange)
        fetchedPhotos.append(contentsOf: photos)
        tableView.finishInfiniteScroll()
        tableView.beginUpdates()
        if tableView.cellForRow(at: IndexPath(item: 0, section: 0)) is EmptyStateTableViewCell, currentPage == InitialPageIndex {
            tableView.deleteSections(IndexSet(integer: 0), with: .none)
        }
        tableView.insertSections(indexSet, with: .fade)
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
        refreshControl.endRefreshing()
        currentPage = currentPage + 1
    }
    
    // MARK: - Helpers
    
    func stateChangeHandler(state: ContainerViewState) {
        container.state = state
        postPreparedNotificationIfNeeded()
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
            guard let strongSelf = self, !strongSelf.fetchedPhotos.isEmpty else {
                return
            }
            let photo = strongSelf.fetchedPhotos[indexPath.section]
            guard photo.smallImage == nil else {
                return
            }
            self?.image(forPhoto: photo, atPath: indexPath)
        }
    }
    
    func header(forSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PhotoHeader.reuseIdentifier) as? PhotoHeader, !fetchedPhotos.isEmpty else {
            return .none
        }
        let photo = fetchedPhotos[section]
        header.setupInfo(forPhoto: photo)
        return header
    }
    
    func height(forSection section: Int) -> CGFloat {
        guard !fetchedPhotos.isEmpty else {
            return 0
        }
        return 35
    }
    
    func height(forRowAtIndex rowIndex: Int) -> CGFloat {
        guard !fetchedPhotos.isEmpty else {
            return tableView.bounds.height
        }
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
                self?.container.handle(error: error)
            }
        )
    }
    
    fileprivate func emptyStateCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.reuseIdentifier, for: indexPath)
        guard let emptyStateCell = cell as? EmptyStateTableViewCell else {
            return cell
        }
        emptyStateCell.emptyStateViewType = .photosTable
        return emptyStateCell
    }
    
    fileprivate func photoCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath)
        guard let photoCell = cell as? PhotoTableViewCell else {
            return cell
        }
        let photo = fetchedPhotos[indexPath.section]
        photoCell.configure(forPhoto: photo)
        photoCell.onSaveButton = { [weak self] photo in
            self?.onPhotoSave?(photo)
        }
        return photoCell
    }
    
}

extension PhotosTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !fetchedPhotos.isEmpty else {
            return 1
        }
        return fetchedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !fetchedPhotos.isEmpty else {
            return emptyStateCell(forIndexPath: indexPath)
        }
        return photoCell(forIndexPath: indexPath)
    }
}
