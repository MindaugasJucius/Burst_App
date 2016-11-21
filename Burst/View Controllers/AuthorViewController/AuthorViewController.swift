import UIKit
import BurstAPI

class AuthorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var dataSource: AuthorViewControllerDataSource!
    var user: User? {
        didSet {
            configureCommonState()
        }
    }
    
    var state: ContainerViewState = .normal

    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
    
}

extension AuthorViewController: StatefulContainerView {
    
    func configureCommonState() {
        guard let user = user else {
            return
        }
        dataSource = AuthorViewControllerDataSource(tableView: tableView, user: user)
        tableView.dataSource = dataSource
        tableView.bounces = false
    }

}
