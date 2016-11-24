import UIKit
import BurstAPI

enum UserInfo {
    case photos
    case collections
}

let UserInfoSectioHeaderReuseID = "UserInfoSectioHeader"
fileprivate let PhotoHeight: CGFloat = 100

class AuthorViewControllerDataSource: NSObject {

    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: UIViewController?
    fileprivate let user: User
    
    fileprivate var availableUserInfo: [UserInfo] = []
    fileprivate var photoCollections: [PhotoCollection] = []
    fileprivate var photos: [Photo] = []
    
    private lazy var photoCollectionsCollectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CollectionSideSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width-CollectionSideSpacing,
            height: CollectionCoverPhotoHeight
        )
        return flowLayout
    }()
    
    private lazy var photoCollectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CollectionSideSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.itemSize = CGSize(
            width: PhotoHeight,
            height: PhotoHeight
        )
        return flowLayout
    }()
    
    init(tableView: UITableView, viewController: UIViewController, user: User) {
        self.tableView = tableView
        self.viewController = viewController
        self.user = user
        super.init()
        registerViews()
        retrieveInfo()
    }
    
    private func retrieveInfo() {
        retrieveCollections(forUser: user)
        retrievePhotos(forUser: user)
    }
    
    private func retrieveCollections(forUser user: User) {
        guard let collectionCount = user.totalCollections,
            collectionCount > 0 else {
            return
        }
        UnsplashGeneric.unsplash(
            getFromURL: user.usersCollectionsLink!,
            success: { [unowned self] (collections: [PhotoCollection]) in
                self.photoCollections = collections
                self.availableUserInfo.append(.collections)
                self.tableView?.reloadData()
                NotificationCenter.default.post(name: ChildUpdateNotificationName, object: nil)
            },
            failure: { [unowned self] error in
                self.viewController?.handle(error: error)
            }
        )
    }
    
    private func retrievePhotos(forUser user: User) {
        UnsplashGeneric.unsplash(
            getFromURL: user.userProfileLinks.photos,
            success: { [unowned self] (photos: [Photo]) in
                self.photos = photos
                self.availableUserInfo.append(.photos)
                self.tableView?.reloadData()
                NotificationCenter.default.post(name: ChildUpdateNotificationName, object: nil)
            },
            failure: { [unowned self] error in
                self.viewController?.handle(error: error)
            }
        )
    }

    private func registerViews() {
        let collectionsCellNib = UINib(nibName: CollectionViewContainerTableViewCell.className, bundle: nil)
        tableView?.register(collectionsCellNib, forCellReuseIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier)
        let headerNib = UINib(nibName: TableViewHeaderWithButton.className, bundle: nil)
        tableView?.register(headerNib, forHeaderFooterViewReuseIdentifier: TableViewHeaderWithButton.reuseIdentifier)
    }
    
    // MARK: - Configure cells
    
    fileprivate func configure(collectionViewContainerCell cell: UITableViewCell, forUserInfo userInfo: UserInfo) -> UITableViewCell {
        guard let containerCell = cell as? CollectionViewContainerTableViewCell else {
            return cell
        }
        switch userInfo {
        case .collections:
            containerCell.layout = photoCollectionsCollectionViewLayout
            containerCell.cellToRegister(cell: PhotoCollectionCollectionViewCell.self)
            containerCell.model = photoCollections
            containerCell.isPagingEnabled = true
        case .photos:
            containerCell.layout = photoCollectionViewLayout
            containerCell.cellToRegister(cell: PhotoCollectionViewCell.self)
            containerCell.model = photos
            containerCell.isPagingEnabled = false
        }
        return containerCell
    }
 
    // MARK: - Delegate helpers
    
    func height(forRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        switch availableUserInfo[indexPath.section] {
        case .collections:
            return CollectionCoverPhotoHeight
        default:
            return PhotoHeight
        }
    }
    
    func header(forSection section: Int) -> UIView? {
        guard let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderWithButton.reuseIdentifier) as? TableViewHeaderWithButton else {
            return nil
        }
        header.configureLabel(
            withTitle: title(forContent: availableUserInfo[section]),
            color: .white,
            font: AppAppearance.regularFont(
                withSize: .headerSubtitle,
                weight: .regular
            )
        )
        return header
    }
    
    private func title(forContent content: UserInfo) -> String {
        var contentCount = 0
        switch content {
        case .photos:
            guard let userPhotoCount = user.totalPhotos else {
                return "\(content)"
            }
            contentCount = userPhotoCount
        case .collections:
            guard let userCollectionCount = user.totalCollections else {
                return "\(content)"
            }
            contentCount = userCollectionCount
        }
        return "\(contentCount) \(content)"
    }
    
}

extension AuthorViewControllerDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return availableUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier, for: indexPath)
        guard availableUserInfo.count > 0 else {
            return cell
        }
        return configure(collectionViewContainerCell: cell,
                         forUserInfo: availableUserInfo[indexPath.section])
    }
    
}
