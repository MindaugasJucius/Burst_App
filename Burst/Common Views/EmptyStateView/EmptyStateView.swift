fileprivate let LabelInsets = UIEdgeInsets(top: 5, left: 10, bottom: 1, right: 10)

class EmptyStateView: UIView {

    @IBOutlet weak var label: InsetLabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    private var emptyStateViewType: EmptyStateViewType = .photoSearch
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        label.font = AppAppearance.regularFont(withSize: .systemSize)
        label.textColor = AppAppearance.white
        label.textInsets = LabelInsets
        backgroundColor = AppAppearance.tableViewBackground
        containerView.backgroundColor = AppAppearance.tableViewBackground
    }
    
    private func createUpperBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        return path
    }
    
    private func createShapeLayer(withPath path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        return shapeLayer
    }
    
    func configure(forType type: EmptyStateViewType) {
        label.text = type.translation
    }
    
    func addSeparator() {
        let shapeLayer = createShapeLayer(withPath: createUpperBezierPath())
        let upperLayer = AppAppearance.mainGradientLayer(withMask: shapeLayer, andFrame: label.bounds)
        label.layer.addSublayer(upperLayer)
    }
}
