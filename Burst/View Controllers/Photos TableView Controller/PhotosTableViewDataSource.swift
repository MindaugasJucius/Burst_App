import UIKit
import BurstAPI

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
    
    private func prepareForRetrieval() {
        tableView.addInfiniteScroll(handler: { [weak self] tableView in
                self?.retrievePhotos()
            }
        )
    }
    
    private func retrievePhotos() {
        UnsplashPhotos.photos(forPage: currentPage, completion: { [weak self] photos, error in
                guard let photos = photos else {
                    AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(onController: self?.viewController,
                                                                                       withError: error)
                    self?.tableView.finishInfiniteScroll()
                    return
                }
                self?.updateTableView(forPhotos: photos)
            }
        )
    }
    
    private func updateTableView(forPhotos photos: [Photo]) {
        let photoGroup = DispatchGroup()
        photos.forEach { photo in
            photoGroup.enter()
            UnsplashImages.getPhotoImage(photo.urls.small,
                success: { image in
                    photo.thumbImage = image
                    photoGroup.leave()
                },
                failure: { error in
                                            
                }
            )
        }
        photoGroup.notify(queue: DispatchQueue.main,
            execute: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.update(forPhotos: photos)
            }
        )
    }
    
    func update(forPhotos photos: [Photo]) {
        var indexPaths = [IndexPath]()
        let previousCount = fetchedPhotos.count
        var currentCount = previousCount
        // create index paths for affected items
        for _ in photos {
            let indexPath = IndexPath(item: 0, section: currentCount)
            indexPaths.append(indexPath)
            currentCount = currentCount + 1
        }
        fetchedPhotos.append(contentsOf: photos)
        
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integersIn: Range(uncheckedBounds: (lower: previousCount, upper: currentCount))), with: .fade)
        tableView.insertRows(at: indexPaths, with: .none)
        tableView.endUpdates()
        tableView.finishInfiniteScroll()
        tableView.reloadData()
        currentPage = currentPage + 1
    }
    
    private func registerViews() {
        //let cellNib = UINib.init(nibName: PhotoTableViewCell.className(), bundle: nil)
        let headerNib = UINib.init(nibName: PhotoHeader.className(), bundle: nil)
        
        //tableView.register(cellNib, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: PhotoHeader.reuseIdentifier)
    }
    
    func configureHeader(forView view: PhotoHeader, atSection section: Int) {
        let photo = fetchedPhotos[section]
        view.setupInfo(forPhoto: photo)
    }
    
    // MARK: - Cell configuration
    
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
