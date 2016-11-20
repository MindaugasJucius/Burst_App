typealias BorderPoints = (start: CGPoint, end: CGPoint)

enum Border {
    case top
    case bottom
    case right
    case left
}

extension UIView {
    
    private func points(forBorder border: Border) -> BorderPoints {
        switch border {
        case .left:
            return (CGPoint.zero,
                    CGPoint(x: 0, y: frame.maxY))
        case .right:
            return (CGPoint(x: frame.maxX, y: 0),
                    CGPoint(x: frame.maxX, y: frame.maxY))
        case .top:
            return (CGPoint.zero,
                    CGPoint(x: frame.maxX, y: 0))
        case .bottom:
            return (CGPoint(x: frame.maxX, y: 0),
                    CGPoint(x: frame.maxX, y: frame.maxY))
        }
    }
    
    
    func add(borderTo border: Border, width: CGFloat , color: UIColor) {
        let borderPoints = points(forBorder: border)
        let pathForBorder = createPath(forBorderPoints: borderPoints)
        let borderLayer = createShapeLayer(withPath: pathForBorder, width: width, color: color)
        layer.addSublayer(borderLayer)
    }
    
    private func createPath(forBorderPoints borderPoints: BorderPoints) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: borderPoints.start)
        path.addLine(to: borderPoints.end)
        return path
    }
    
    private func createShapeLayer(withPath path: UIBezierPath, width: CGFloat, color: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        return shapeLayer
    }
    
}
