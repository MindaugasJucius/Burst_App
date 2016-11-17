import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var panYVelocity: CGFloat = 0
    
    var state: ContainerViewState = .normal
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
                photoDetailsCell.animateDismissal()
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
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
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
    
    fileprivate func setup(photoDetailsCell: PhotoDetailsTableViewCell) -> PhotoDetailsTableViewCell {
        //photoDetailsCell.isUserInteractionEnabled = false
        photoDetailsCell.parentTableView = tableView
        photoDetailsCell.didEndPanWithPositiveVelocity = { [unowned self] in
            self.scrollToTop()
        }
        photoDetailsCell.didEndPanWithNegativeVelocity = { [unowned self] in
            self.scrollToCellAt(atIndexPath: IndexPath(item: 1, section: 0))
        }
        return photoDetailsCell
    }
}

extension PhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotoDetailsTableViewCell.reuseIdentifier,
                for: indexPath
            )
            guard let photoDetailsCell = cell as? PhotoDetailsTableViewCell else {
                return cell
            }
            return setup(photoDetailsCell: photoDetailsCell)
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FullPhotoTableViewCell.reuseIdentifier,
                for: indexPath
            )
            cell.backgroundColor = .red
            return cell
        }
    }
}

extension PhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.bounds.height
        }
        return view.bounds.height * 0.75
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let photoDetailsCell = tableView.visibleCells.last as? PhotoDetailsTableViewCell else { return }
        if panYVelocity < 0 {
            photoDetailsCell.animatePresentation()
        }
    }
}

extension PhotoViewController: StatefulContainerView {
    
    func configureCommonState() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handle(panGesture:)))
        registerViews()
    }
}
