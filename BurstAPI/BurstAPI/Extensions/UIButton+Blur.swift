public extension UIButton {
    
    public func buttonImageAddGlow() {
        let color = UIColor.white
        guard let imageViewLayer = self.imageView?.layer else { return }
        imageViewLayer.shadowColor = color.cgColor
        imageViewLayer.shadowRadius = 2
        imageViewLayer.shadowOpacity = 1
        imageViewLayer.shadowOffset = CGSize.zero
        imageViewLayer.masksToBounds = false
    }
    
}
