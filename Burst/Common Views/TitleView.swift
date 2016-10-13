import UIKit

fileprivate let ProgressAnimationDuration: CFTimeInterval = 2
fileprivate let LabelInsets = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)

class TitleView: UIView {

    @IBOutlet private weak var titleLabel: InsetLabel!
    
    private var lowerShapeLayer: CAShapeLayer?
    private var upperShapeLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributedString = NSMutableAttributedString(string: APPName)
        attributedString.addAttribute(NSKernAttributeName, value: 3.0, range: NSMakeRange(0, attributedString.length-1))
        titleLabel.attributedText = attributedString
        titleLabel.font = AppAppearance.navigationBarFont()
        titleLabel.textColor = .white
        titleLabel.textInsets = LabelInsets
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
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }
    
    private func beginProgressAnimationTransaction() {
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setAnimationDuration(ProgressAnimationDuration)
        upperShapeLayer?.add(progressAnimation(), forKey: nil)
        lowerShapeLayer?.add(progressAnimation(), forKey: nil)
        upperShapeLayer?.add(fadeOutAnimation(withDelay: ProgressAnimationDuration), forKey: nil)
        lowerShapeLayer?.add(fadeOutAnimation(withDelay: ProgressAnimationDuration), forKey: nil)
        CATransaction.commit()
    }
    
    // MARK: - Animations
    
    private func progressAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.setValue("drawProgress", forKey: "animID")
        return animation
    }
    
    func fadeOutAnimation(withDelay delay: CFTimeInterval) -> CABasicAnimation {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.beginTime = CACurrentMediaTime() + delay
        fadeOutAnimation.setValue("fadeProgress", forKey: "animID")
        return fadeOutAnimation
    }
    
    // MARK: - Public methods
    
    func beginAnimation() {
        beginProgressAnimationTransaction()
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
