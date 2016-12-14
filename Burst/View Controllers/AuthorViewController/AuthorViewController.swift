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

}

extension AuthorViewController: PhotoInfoContentController {
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
    
}

extension AuthorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: UserInfoSectionHeaderReuseID)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        dataSource.configure(headerView: view, inSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.height(forRowAtIndexPath: indexPath)
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
