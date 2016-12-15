import Unbox

protocol ReusableView: class {
    func configure(withAny any: Any)
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return className + "reuseIdentifier"
    }
    
}

extension ReusableView {
    func configure(withAny any: Any) { }
}
