import Unbox

protocol ReusableView {

    associatedtype ReusableViewType
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


struct AnyReusableView<ViewType> : ReusableView, Hashable, Equatable {
    
    // A reference to the underlying parser's parse() method
    private let _configure : (Any) -> ()
    private let base: Any
    
    typealias ReusableViewType = ViewType
    // Accept any base that conforms to Parser, and has the same Result type
    // as the type erasure's generic parameter
    init<T:ReusableView>(_ base:T) where T.ReusableViewType == ViewType {
        _configure = base.configure
        self.base = base
    }
    
    // Forward calls to parse() to the underlying parser's method
    func configure(withAny any: Any) {
        _configure(any)
    }
    
    var hashValue: Int {
        get {
            return "\(base)".hashValue
        }
    }
    
    public static func ==(lhs: AnyReusableView, rhs: AnyReusableView) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
