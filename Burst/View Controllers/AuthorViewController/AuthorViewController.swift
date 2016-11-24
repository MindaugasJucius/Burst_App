import UIKit
import BurstAPI

class AuthorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var dataSource: AuthorViewControllerDataSource!
    
    var user: User?
    var state: ContainerViewState = .normal
    
    private var containedInTableView = false
    
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

extension AuthorViewController: StatefulContainerView {
    
    func configureCommonState() {
        guard let user = user else {
            return
        }
        dataSource = AuthorViewControllerDataSource(tableView: tableView, viewController: self, user: user)
        tableView.dataSource = dataSource
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppAppearance.tableViewBackground
    }

}
