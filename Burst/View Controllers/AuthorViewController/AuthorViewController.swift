import UIKit
import BurstAPI

class AuthorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var containedInTableView = false
    fileprivate var dataSource: AuthorViewControllerDataSource!
    
    var user: User?
    var state: ContainerViewState = .normal
    
    static func instantiate(forPhotoDetails: Bool) -> AuthorViewController? {
        let controller = AuthorViewController.fromStoryboard()
        controller?.containedInTableView = forPhotoDetails
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
    }
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
    
}

extension AuthorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.header(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CollectionCoverPhotoHeight
    }
    
}

extension AuthorViewController: StatefulContainerView {
    
    func configureCommonState() {
        guard let user = user else {
            return
        }
        dataSource = AuthorViewControllerDataSource(tableView: tableView, viewController: self, user: user)
        if containedInTableView {
            tableView.tableHeaderView = nil
        }
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 30
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppAppearance.tableViewBackground
    }

}
