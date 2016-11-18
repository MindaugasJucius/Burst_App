import UIKit
import BurstAPI

class PhotoViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var panYVelocity: CGFloat = 0
    fileprivate let photo: Photo
    fileprivate var dataSource: PhotoViewControllerDataSource!
    
    var state: ContainerViewState = .normal
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: PhotoViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    // MARK: - Additional scrolling logic
    
    @objc func handle(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .changed:
            let yVelocity = panGesture.velocity(in: view).y
            if yVelocity != 0 {
                panYVelocity = yVelocity
            }
        case .ended, .cancelled, .failed:
            guard let visibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = visibleRows.last,
                visibleRows.count > 1 else {
                    return
            }
            if panYVelocity < 0 {
                scrollToCellAt(atIndexPath: lastIndexPath)
            } else {
                guard let photoDetailsCell = tableView.cellForRow(at: lastIndexPath) as? PhotoDetailsTableViewCell else {
                    return
                }
                photoDetailsCell.animateDetails(toState: .dismissed)
                scrollToTop()
            }
        default:
            return
        }
    }
    
    // MARK: - Scrolling animations
    
    func scrollToTop() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.tableView.setContentOffset(CGPoint.zero, animated: false)
            },
            completion: nil
        )
    }
    
    func scrollToCellAt(atIndexPath indexPath: IndexPath)  {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: { [unowned self] in
                let cellsRect = cell.frame
                if cellsRect.height > self.view.frame.height * 0.75 {
                    let targetOffset = CGPoint(x: 0, y: cellsRect.origin.y * 0.75)
                    self.tableView.setContentOffset(targetOffset, animated: false)
                } else {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            },
            completion: { finished in
                cell.isUserInteractionEnabled = true
            }
        )
    }
    
    // MARK: - Setup
 
    fileprivate func registerViews() {
        let fullCellNib = UINib.init(nibName: FullPhotoTableViewCell.className, bundle: nil)
        let photoDetailsCellNib = UINib.init(nibName: PhotoDetailsTableViewCell.className, bundle: nil)
        tableView.register(fullCellNib, forCellReuseIdentifier: FullPhotoTableViewCell.reuseIdentifier)
        tableView.register(photoDetailsCellNib, forCellReuseIdentifier: PhotoDetailsTableViewCell.reuseIdentifier)
    }
    
    fileprivate func setupDataSource() -> PhotoViewControllerDataSource {
        let dataSource = PhotoViewControllerDataSource(tableView: tableView, photo: photo)
        dataSource.didEndPanWithNegativeVelocity = { [unowned self] in
            self.scrollToCellAt(atIndexPath: IndexPath(item: 1, section: 0))
        }
        dataSource.didEndPanWithPositiveVelocity = { [unowned self] in
            self.scrollToTop()
        }
        dataSource.didTapClosePhotoPreview = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false
        }
        return dataSource
    }
    
}

extension PhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.cellHeight(forRowAt: indexPath)
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let photoDetailsCell = tableView.visibleCells.last as? PhotoDetailsTableViewCell else { return }
        if panYVelocity < 0 {
            photoDetailsCell.animateDetails(toState: .presented)
        }
    }
}

extension PhotoViewController: StatefulContainerView {
    
    func configureCommonState() {
        dataSource = setupDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.bounces = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handle(panGesture:)))
        registerViews()
    }
}
