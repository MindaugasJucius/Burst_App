import UIKit

class MainTabBar: UITabBar {

    private let indexView = UIView()
    private let backgroundColorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        barTintColor = AppAppearance.lightBlack
        tintColor = .white
        addSubview(indexView)
        insertSubview(backgroundColorView, belowSubview: indexView)

    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sizeThatFits = super.sizeThatFits(size)
        return CGSize(width: sizeThatFits.width, height: sizeThatFits.height / 1.5)
    }
    
    // MARK: - Public methods
    
    func setupBar() {
        updateIndexViewWidth()
        updateBackgroundView()
        updateIndexView(toPosition: 0)
        indexView.layer.addSublayer(createShapeLayer(withPath: createBezierPath()))
    }
    
    func updateBar(toPosition index: Int) {
        updateIndexView(toPosition: index)
    }
    
    // MARK: - Private methods
    
    private func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        let viewFrame = indexView.frame
        let length = viewFrame.width / 2
        let beginningX = (viewFrame.width - length) / 2
        path.move(to: CGPoint(x: beginningX, y: 0))
        path.addLine(to: CGPoint(x: beginningX + length,
                                 y: 0))
        return path
    }
    
    private func createShapeLayer(withPath path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = AppAppearance.malibuBlue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.5
        return shapeLayer
    }
    
    func updateBackgroundView() {
        let width = UIScreen.main.bounds.width
        backgroundColorView.frame = CGRect(x: 0,
                                           y: -1,
                                           width: width,
                                           height: frame.height)
        backgroundColorView.backgroundColor = AppAppearance.lightBlack
    }
    
    private func updateIndexViewWidth() {
        guard let itemsCount = items?.count else {
            return
        }
        let width = UIScreen.main.bounds.width / CGFloat(itemsCount)
        indexView.frame = CGRect(x: indexView.frame.minX,
                                 y: indexView.frame.minY,
                                 width: width,
                                 height: frame.height)
    }
    
    private func updateIndexView(toPosition position: Int, animated: Bool = true) {
        let endFrame = CGPoint(x: indexView.frame.width * CGFloat(position), y: 0)
        guard animated else {
            indexView.frame.origin = endFrame
            return
        }
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let indexView = strongSelf.indexView
                indexView.frame.origin = endFrame
            },
            completion: nil
        )
    }

}
