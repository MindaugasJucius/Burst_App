public extension UIColor {

    public func isLight() -> Bool
    {
        let components = self.cgColor.components
        let componentFirstColor = components?[0]
        let componentSecondColor = components?[1]
        let brightness = ((componentFirstColor! * 299) + (componentSecondColor! * 587) + ((components?[2])! * 114))
        
        if brightness < 700
        {
            return false
        }
        else
        {
            return true
        }
    }
    
}
