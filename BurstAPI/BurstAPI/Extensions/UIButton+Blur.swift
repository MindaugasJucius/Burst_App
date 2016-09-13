public extension UIButton {
    
    public func buttonImageAddGlow() {
        let color = UIColor.whiteColor()
        guard let imageViewLayer = self.imageView?.layer else { return }
        imageViewLayer.shadowColor = color.CGColor
        imageViewLayer.shadowRadius = 2
        imageViewLayer.shadowOpacity = 1
        imageViewLayer.shadowOffset = CGSizeZero
        imageViewLayer.masksToBounds = false
    }
    
}
