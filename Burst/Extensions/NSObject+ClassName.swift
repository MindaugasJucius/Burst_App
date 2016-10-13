extension NSObject {
    
    static func className() -> String {
        return String(describing: self)
    }

}
