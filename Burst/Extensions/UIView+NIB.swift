extension UIView {
    
    class func loadFromNib<U: UIView>() -> U? {
        return load(fromNibWithName: U.className)
    }
    
    class func load<U: UIView>(fromNibWithName nibName: String) -> U? {
        return load(fromNibWithName: nibName, fromBundle: Bundle.init(for: U.self))
    }
    
    class func load<U: UIView>(fromNibWithName nibName: String, fromBundle bundle: Bundle) -> U? {
        let nib = UINib(nibName: nibName, bundle: bundle)
        let elements = nib.instantiate(withOwner: nil, options: nil)
        return elements.filter { $0 is U }.first as? U
    }

}
