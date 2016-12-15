import UIKit
import BurstAPI

enum UserInfo {
    case photos
    case collections
}

let UserInfoSectionHeaderReuseID = "UserInfoSectionHeader"
fileprivate let PhotoHeight: CGFloat = 100
fileprivate let SideInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

class AuthorViewControllerDataSource: NSObject {

    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: UIViewController?
    fileprivate unowned var user: User
    fileprivate let dataController: AuthorDataController
    fileprivate let onError: ErrorCallback
    
    fileprivate var availableUserInfo: [UserInfo] = []
    fileprivate var photoCollections: [PhotoCollection] = []
    fileprivate var photos: [Photo] = []
    
    private lazy var photoCollectionsCollectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 30
        flowLayout.sectionInset = SideInset
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width-30,
            height: CollectionCoverPhotoHeight
        )
        return flowLayout
    }()
    
    private lazy var photoCollectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CollectionSideSpacing
        flowLayout.sectionInset = SideInset
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
        self.onError = { error in
        }
        self.dataController = AuthorDataController(user: user, onError: onError)
        super.init()
        registerViews()
        retrieveInfo()
    }
    
    private func retrieveInfo() {
        dataController.fetchUserInfo(
            success: { [unowned self] userInfo in
                if let collections = userInfo.collections {
                    self.photoCollections = collections
                    self.availableUserInfo.append(.collections)
                }
                if let photos = userInfo.photos {
                    self.photos = photos
                    self.availableUserInfo.append(.photos)
                }
                self.tableView?.reloadData()
                NotificationCenter.default.post(name: ChildUpdateNotificationName, object: nil)
            }
        )
    }

    private func registerViews() {
        let collectionsCellNib = UINib(nibName: CollectionViewContainerTableViewCell.className, bundle: nil)
        tableView?.register(collectionsCellNib, forCellReuseIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier)
        tableView?.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: UserInfoSectionHeaderReuseID)
    }
    
    // MARK: - Configure cells
    
    fileprivate func configure(collectionViewContainerCell cell: UITableViewCell, forUserInfo userInfo: UserInfo) -> UITableViewCell {
        guard let containerCell = cell as? CollectionViewContainerTableViewCell else {
            return cell
        }
        switch userInfo {
        case .collections:
            containerCell.layout = photoCollectionsCollectionViewLayout
            containerCell.cellToRegister(cell: PhotoCollectionCollectionViewCell.self, cellConfigurationCallback: nil)
            containerCell.model = photoCollections
            containerCell.isPagingEnabled = true
        case .photos:
            containerCell.layout = photoCollectionViewLayout
            containerCell.cellToRegister(cell: ImageViewCollectionViewCell.self,
                cellConfigurationCallback: { contentView in
                    contentView.layer.cornerRadius = 6
                }
            )
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
    
    func configure(headerView: UIView, inSection section: Int) {
        guard let header = headerView as? UITableViewHeaderFooterView else {
            return
        }
        header.contentView.backgroundColor = AppAppearance.tableViewBackground
        header.textLabel?.font = AppAppearance.regularFont(withSize: .sectionHeaderTitle)
        header.textLabel?.text = title(forContent: availableUserInfo[section])
        header.textLabel?.textColor = AppAppearance.gray666
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
            contentCount = photoCollections.count
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
