import Unbox

protocol ReusableView: class {

    func configure(withAny any: Any)
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return className + "reuseIdentifier"
    }
    
    static func nib() -> UINib? {
        return UINib(nibName: Self.className, bundle: nil)
    }
    
}

extension ReusableView {
    func configure(withAny any: Any) { }
}
