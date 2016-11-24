import UIKit
import BurstAPI

class AuthorViewControllerDataSource: NSObject {

    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: UIViewController?
    fileprivate let user: User
    fileprivate var photoCollections: [PhotoCollection] = []
    
    lazy var photoCollectionsCollectionViewLayout: UICollectionViewFlowLayout = {
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
    
    init(tableView: UITableView, viewController: UIViewController, user: User) {
        self.tableView = tableView
        self.viewController = viewController
        self.user = user
        super.init()
        registerViews()
        retrieveInfo()
    }
    
    private func retrieveInfo() {
        guard let collectionCount = user.totalCollections,
            collectionCount > 0 else {
                return
        }
        retrieveCollections(forUser: user)
    }
    
    private func retrieveCollections(forUser user: User) {
        UnsplashGeneric.unsplash(
            getFromURL: user.usersCollectionsLink!,
            success: { [unowned self] (collections: [PhotoCollection]) in
                self.photoCollections = collections
                self.tableView?.reloadData()
            },
            failure: { [unowned self] error in
                self.viewController?.handle(error: error)
            }
        )
    }

    func registerViews() {
        let collectionsCellNib = UINib(nibName: CollectionViewContainerTableViewCell.className, bundle: nil)
        tableView?.register(collectionsCellNib, forCellReuseIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Configure cells
    
    fileprivate func configure(collectionViewContainerCell cell: UITableViewCell) -> UITableViewCell {
        guard let containerCell = cell as? CollectionViewContainerTableViewCell else {
            return cell
        }
        containerCell.layout = photoCollectionsCollectionViewLayout
        containerCell.cellToRegister(cell: PhotoCollectionCollectionViewCell.self)
        containerCell.model = photoCollections
        return containerCell
    }
    
}

extension AuthorViewControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier, for: indexPath)
        return configure(collectionViewContainerCell: cell)
    }
    
}
