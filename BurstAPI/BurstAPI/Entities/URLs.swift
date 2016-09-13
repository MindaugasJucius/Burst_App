import UIKit
import Unbox

public enum PhotoSize {
    case Full
    case Raw
    case Regular
    case Small
    case Thumb
}

public class URLs: NSObject, Unboxable {
    
    public let full: NSURL
    public let raw: NSURL
    public let regular: NSURL
    public let small: NSURL
    public let thumb: NSURL
    
    required public init(unboxer: Unboxer) {
        self.full = unboxer.unbox("full")
        self.raw = unboxer.unbox("raw")
        self.regular = unboxer.unbox("regular")
        self.small = unboxer.unbox("small")
        self.thumb = unboxer.unbox("thumb")
    }
    
    public init(full: NSURL, raw: NSURL, regular: NSURL, small: NSURL, thumb: NSURL) {
        self.full = full
        self.raw = raw
        self.regular = regular
        self.small = small
        self.thumb = thumb
        super.init()
    }
}
