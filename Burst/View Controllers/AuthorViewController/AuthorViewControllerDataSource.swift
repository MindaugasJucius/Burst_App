import UIKit
import BurstAPI

class AuthorViewControllerDataSource: NSObject {

    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: UIViewController?
    fileprivate let user: User
    fileprivate var photoCollections: [PhotoCollection] = []
    
    init(tableView: UITableView, viewController: UIViewController, user: User) {
        self.tableView = tableView
        self.viewController = viewController
        self.user = user
        super.init()
        registerViews()
        
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
    
}

extension AuthorViewControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
}
