extension UIView {
    
    var allSubviews: [UIView] {
        var array = subviews
        array.forEach {
            array.append(contentsOf: $0.allSubviews)
        }
        return array
    }

    func subview<U>(ofType: U.Type) -> U? {
        let array = allSubviews
        return array.filter {
            $0 is U
        }.first as? U
    }
}
