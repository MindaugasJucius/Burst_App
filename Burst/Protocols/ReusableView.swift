import Unbox

protocol ReusableView: class {
    func configure(withUnboxable unboxable: Unboxable)
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return className + "reuseIdentifier"
    }
    
}

extension ReusableView {
    func configure(withUnboxable unboxable: Unboxable) {
        
    }
}
