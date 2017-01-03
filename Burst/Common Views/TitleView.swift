import UIKit

fileprivate let FadeOutAnimationDuration: CFTimeInterval = 1.5
fileprivate let GreetingsAnimationDuration: CFTimeInterval = 2
fileprivate let LabelInsets = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)

class TitleView: UIView {

    @IBOutlet private weak var titleLabel: InsetLabel!
    
    private var lowerShapeLayer: CAShapeLayer?
    private var upperShapeLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let attributedString = NSMutableAttributedString(string: AppConstants.APPName)
        attributedString.addAttribute(NSKernAttributeName, value: 3.0, range: NSMakeRange(0, attributedString.length-1))
        titleLabel.attributedText = attributedString
        titleLabel.font = AppAppearance.regularFont(withSize: .headerTitle)
        titleLabel.textColor = .white
        titleLabel.textInsets = LabelInsets
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
    
    private func beginGreetingsAnimationTransaction() {
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setAnimationDuration(GreetingsAnimationDuration)
        CATransaction.setCompletionBlock { [weak self] in
            self?.beginFadeOutTransaction()
        }
        upperShapeLayer?.add(progressAnimation(), forKey: nil)
        lowerShapeLayer?.add(progressAnimation(), forKey: nil)
        
        CATransaction.commit()
    }
    
    func beginFadeOutTransaction() {
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setAnimationDuration(FadeOutAnimationDuration)
        CATransaction.setCompletionBlock { [weak self] in
            self?.resetLayerState()
        }
        upperShapeLayer?.add(fadeOutAnimation(), forKey: nil)
        lowerShapeLayer?.add(fadeOutAnimation(), forKey: nil)
        upperShapeLayer?.opacity = 0
        lowerShapeLayer?.opacity = 0
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
    
    private func fadeOutAnimation() -> CABasicAnimation {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.setValue("fadeProgress", forKey: "animID")
        return fadeOutAnimation
    }
    
    // MARK: - Progress animation handling
    
    private func resetLayerState() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        upperShapeLayer?.strokeEnd = CGFloat(0)
        lowerShapeLayer?.strokeEnd = CGFloat(0)
        upperShapeLayer?.opacity = 1
        lowerShapeLayer?.opacity = 1
        CATransaction.commit()
    }
    
    // MARK: - Public methods
    
    func beginAnimation() {
        beginGreetingsAnimationTransaction()
    }
    
    func update(withOffset offset: Double) {
        upperShapeLayer?.strokeEnd = CGFloat(offset)
        lowerShapeLayer?.strokeEnd = CGFloat(offset)
        if offset == 1.0 {
            upperShapeLayer?.strokeEnd = CGFloat(0)
            lowerShapeLayer?.strokeEnd = CGFloat(0)
        }
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
