import UIKit
import BurstAPI

fileprivate let TopTableViewSpacing: CGFloat = 75

let ChildUpdateNotificationName = Notification.Name("ChildUpdateNotification")

typealias AnimationProperties = (
    delay: TimeInterval,
    duration: TimeInterval,
    topSpacing: CGFloat,
    alpha: CGFloat
)

enum PresentationState: Int {
    case presented
    case dismissed
    
    fileprivate var animationProperties: AnimationProperties {
        switch self {
        case .presented:
            return (0.1, 0.4, 0, 1)
        case .dismissed:
            return (0, 0.3, TopTableViewSpacing, 0)
        }
    }
}

class PhotoDetailsTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak fileprivate var topTableViewSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var tableView: UITableView!
    fileprivate var dataSource: PhotoDetailsDataSource!
    
    private var initialDiff: CGFloat = 0
    private var lastYVelocity: CGFloat = 0
    private var presentationState: PresentationState = .dismissed
    
    var state: ContainerViewState = .normal
    weak var parentTableView: UITableView?
    var didEndPanWithPositiveVelocity: (() -> ())?
    var didEndPanWithNegativeVelocity: (() -> ())?
    var heightForPhotoDetails: ((IndexPath) -> (CGFloat))?
    var photoInfoViews: CorrespondingInfoViews = [:]
    
    var photo: Photo? {
        didSet {
            configureCommonState()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        parentTableView = nil
        presentationState = .dismissed
        initialDiff = 0
        lastYVelocity = 0
        NotificationCenter.default.removeObserver(self, name: ChildUpdateNotificationName, object: nil)
    }
    
    // MARK: - Additional scrolling logic
    
    @objc func handle(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .changed:
            if tableView.contentOffset.y <= 0 {
                scrollParentTableView(withPanGesture: panGesture)
            } else {
                resetState()
            }
        case .ended, .cancelled, .failed:
            guard tableView.contentOffset.y <= 0 else {
                return
            }
            handlePanFinish()
        default:
            return
        }
    }
    
    private func scrollParentTableView(withPanGesture panGesture: UIPanGestureRecognizer) {
        guard let parentTableView = parentTableView, parentTableView.contentOffset.y > 0 else { return }
        tableView.bounces = false
        let yLocation = panGesture.location(in: parentTableView).y
        let yVelocity = panGesture.velocity(in: parentTableView).y
        if yVelocity != 0 {
            lastYVelocity = yVelocity
        }
        if initialDiff == 0 {
            initialDiff = yLocation
        }
        let currentDiff = initialDiff - yLocation
        let parentYOffset = parentTableView.contentOffset.y + currentDiff
        let parentOffset = CGPoint(x: 0, y: parentYOffset)
        parentTableView.setContentOffset(parentOffset, animated: false)
    }
    
    private func resetState() {
        tableView.bounces = true
        initialDiff = 0
        lastYVelocity = 0
    }
    
    private func handlePanFinish() {
        if lastYVelocity > 0 {
            didEndPanWithPositiveVelocity?()
            animateDetails(toState: .dismissed)
        } else {
            didEndPanWithNegativeVelocity?()
        }
        resetState()
    }
    
    fileprivate func handleChildUpdateNotification() {
        NotificationCenter.default.addObserver(
            forName: ChildUpdateNotificationName,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                self?.handleChildUpdate()
            }
        )
        
    }
    
    private func handleChildUpdate() {
        tableView.reloadData()
    }
    
    // MARK: - Details content animation
    
    func animateDetails(toState state: PresentationState) {
        guard presentationState != state else {
            return
        }
        presentationState = state
        let properties = state.animationProperties
        layoutIfNeeded()
        UIView.animate(
            withDuration: properties.duration,
            delay: properties.delay,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.topTableViewSpacingConstraint.constant = properties.topSpacing
                self.tableView.alpha = properties.alpha
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
}

extension PhotoDetailsTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderWithButton.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        dataSource.configure(headerView: view, forSection: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let heightClosure = heightForPhotoDetails else {
            return TableViewCellDefaultHeight
        }
        return heightClosure(indexPath)
    }
    
}

extension PhotoDetailsTableViewCell: StatefulContainerView {
    
    func configureCommonState() {
        guard let photo = photo else { return }
        handleChildUpdateNotification()
        topTableViewSpacingConstraint.constant = TopTableViewSpacing
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        dataSource = PhotoDetailsDataSource(
            tableView: tableView,
            photo: photo,
            correspondingViews: photoInfoViews
        )
        tableView.dataSource = dataSource
        tableView.alpha = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        for case let subview as UIScrollView in tableView.subviews {
            subview.delaysContentTouches = false
        }
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handle(panGesture:)))
    }
}
