import UIKit
import BurstAPI

class PhotosTableViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var delegate: ContainerControllerDelegate?
    
    fileprivate var dataSource: PhotosTableViewDataSource!
    fileprivate var headerHolder: UIView?
    
    var state: ContainerViewState = .normal {
        didSet {
            updateView(forState: state)
            if oldValue != state {
                tableView.reloadData()
            }
        }
    }
    
    // Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
        updateView(forState: .normal)
    }
    
    // Mark: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        guard let header = tableView.tableHeaderView as? PhotosTableHeaderView else {
            return
        }
        headerHolder = header
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        guard frame.size.height != height else {
            return
        }
        frame.size.height = height
        header.frame = frame
        tableView.tableHeaderView = header
    }
    
    // Mark: - Navigation
    
    func presentDetails(forPhoto photo: Photo) {
        let photoViewController = PhotoViewController(photo: photo)
        navigationController?.isNavigationBarHidden = true
        photoViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoViewController, animated: true)
    }
    
    // Mark: - Configuration
    
    fileprivate func setupDataSource() {
        dataSource = PhotosTableViewDataSource(tableView: tableView, viewController: self)
        dataSource.onPhotoSave = { [weak self] photo in
            guard let unwrappedPhoto = photo else {
                return
            }
            self?.delegate?.downloadPhoto(unwrappedPhoto)
        }
        tableView.dataSource = dataSource
    }
    
}

extension PhotosTableViewController: StatefulContainerView {
    
    func configureEmptyState() {
        tableView.tableHeaderView = nil
    }
    
    func configureNormalState() {
        guard headerHolder != nil else {
            headerHolder = tableView.tableHeaderView
            return
        }
        tableView.tableHeaderView = headerHolder
    }
    
    func configureCommonState() {
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.infiniteScrollIndicatorStyle = .white
        tableView.infiniteScrollTriggerOffset = tableView.bounds.height
        for case let subview as UIScrollView in tableView.subviews {
            subview.delaysContentTouches = false
        }
        tableView.separatorStyle = .none
        tableView.delegate = self
        setupDataSource()
    }
}

extension PhotosTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.header(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.height(forRowAtIndex: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.height(forSection: section)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dataSource.downloadImagesForVisibleCells()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else {
            return
        }
        dataSource.downloadImagesForVisibleCells()
    }
    
}
