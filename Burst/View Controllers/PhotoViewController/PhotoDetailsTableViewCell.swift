import UIKit

fileprivate let DetailsCellReuseId = "DetailsCell"
fileprivate let TopTableViewSpacing: CGFloat = 75

typealias AnimationProperties = (
    delay: TimeInterval,
    duration: TimeInterval,
    topSpacing: CGFloat,
    alpha: CGFloat
)

enum PresentationState: Int {
    case presented
    case dismissed
    
    var animationProperties: AnimationProperties {
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
    
    private var initialDiff: CGFloat = 0
    private var lastYVelocity: CGFloat = 0
    private var presented: Bool = false
    private var presentationState: PresentationState = .dismissed
    
    weak var parentTableView: UITableView?
    var didEndPanWithPositiveVelocity: (() -> ())?
    var didEndPanWithNegativeVelocity: (() -> ())?
    
    var state: ContainerViewState = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCommonState()
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
        guard let parentTableView = parentTableView else { return }
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
    
    // MARK: - Details content presentation/dismissal animations
    
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

extension PhotoDetailsTableViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellReuseId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}

extension PhotoDetailsTableViewCell: StatefulContainerView {
    
    func handle(error: Error) {
        
    }
    
    func configureCommonState() {
        topTableViewSpacingConstraint.constant = TopTableViewSpacing
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DetailsCellReuseId)
        tableView.dataSource = self
        tableView.alpha = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handle(panGesture:)))
    }
}
