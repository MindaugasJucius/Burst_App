import UIKit
import Unbox

public enum PhotoSize {
    case full
    case raw
    case regular
    case small
    case thumb
}

open class URLs: NSObject, Unboxable {
    
    open let full: URL
    open let raw: URL
    open let regular: URL
    open let small: URL
    open let thumb: URL
    
    required public init(unboxer: Unboxer) {
        self.full = unboxer.unbox("full")
        self.raw = unboxer.unbox("raw")
        self.regular = unboxer.unbox("regular")
        self.small = unboxer.unbox("small")
        self.thumb = unboxer.unbox("thumb")
    }
    
    public init(full: URL, raw: URL, regular: URL, small: URL, thumb: URL) {
        self.full = full
        self.raw = raw
        self.regular = regular
        self.small = small
        self.thumb = thumb
        super.init()
    }
}
