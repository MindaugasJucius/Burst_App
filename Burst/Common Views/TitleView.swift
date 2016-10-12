import UIKit

class TitleView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    private var lowerShapeLayer: CAShapeLayer?
    private var upperShapeLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = APPName
        titleLabel.font = AppAppearance.navigationBarFont()
        titleLabel.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func createUpperBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        let labelFrame = titleLabel.frame
        path.move(to: CGPoint(x: labelFrame.width/2, y: 0))
        path.addLine(to: CGPoint(x: labelFrame.width, y: 0))
        path.addLine(to: CGPoint(x: labelFrame.width, y: labelFrame.height))
        path.addLine(to: CGPoint(x: labelFrame.width/2, y: labelFrame.height))
        return path
    }
    
    private func createLowerBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        let labelFrame = titleLabel.frame
        path.move(to: CGPoint(x: labelFrame.width/2, y: labelFrame.height))
        path.addLine(to: CGPoint(x: 0, y: labelFrame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: labelFrame.width/2, y: 0))
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
    
    // MARK: - Public methods
    
    func beginAnimation() {
        
    }
    
    func configure() {
        let upperLayer = createShapeLayer(withPath: createUpperBezierPath())
        let lowerLayer = createShapeLayer(withPath: createLowerBezierPath())
        self.upperShapeLayer = upperLayer
        self.lowerShapeLayer = lowerLayer
        titleLabel.layer.addSublayer(upperLayer)
        titleLabel.layer.addSublayer(lowerLayer)
    }
    
}
