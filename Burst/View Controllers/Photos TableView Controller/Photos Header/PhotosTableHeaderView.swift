import UIKit

fileprivate let LabelSeparatorOffset: CGFloat = 10

class PhotosTableHeaderView: UIView {
    
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLabel.textColor = AppAppearance.subtitleColor
        bottomLabel.font = AppAppearance.condensedFont(withSize: .headerSubtitle)
        topLabel.textColor = AppAppearance.white
        topLabel.font = AppAppearance.condensedFont(withSize: .headerTitle)
        topLabel.text = NewPhotosTitle.uppercased()
        bottomLabel.text = NewPhotosSubtitle
    }
    
    private func createSeparatorBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        let labelFrame = bottomLabel.frame
        let separatorYCoord = labelFrame.height + LabelSeparatorOffset
        path.move(to: CGPoint(x: 0, y: separatorYCoord))
        path.addLine(to: CGPoint(x: labelFrame.width/2, y: separatorYCoord))
        return path
    }

    private func createShapeLayer(withPath path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = AppAppearance.lightBlue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLabel.preferredMaxLayoutWidth = topLabel.bounds.width
        bottomLabel.preferredMaxLayoutWidth = bottomLabel.bounds.width
    }
    
    func configureSeparator() {
        let separatorLayer = createShapeLayer(withPath: createSeparatorBezierPath())
        bottomLabel.layer.addSublayer(separatorLayer)
    }
}
