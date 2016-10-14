import UIKit

class PhotosTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: PhotosTableViewDataSource!

    // Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // Mark: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        guard let header = headerView as? PhotosTableHeaderView else {
            return
        }
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        tableView.tableHeaderView = header
        header.configureSeparator()
    }
    
    // Mark: - Configuration
    
    private func setupTableView() {
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        for case let subview as UIScrollView in tableView.subviews {
            subview.delaysContentTouches = false
        }
        tableView.separatorStyle = .none
        tableView.delegate = self
        setupDataSource()
        configureDimensions()
    }
    
    private func setupDataSource() {
        dataSource = PhotosTableViewDataSource(tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    private func configureDimensions() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 30
        tableView.estimatedRowHeight = 360
    }
}

extension PhotosTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PhotoHeader.reuseIdentifier)
        return header
    }
}
