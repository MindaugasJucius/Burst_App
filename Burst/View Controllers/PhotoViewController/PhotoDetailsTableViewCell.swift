import UIKit

class PhotoDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var topTableViewSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    var state: ContainerViewState = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

extension PhotoDetailsTableViewCell: StatefulContainerView {
    
    func handle(error: Error) {
        
    }
    
    func configureNormalState() {
        
    }
    
    func configureEmptyState() {
        
    }
    
    func configureCommonState() {
        
    }
}
