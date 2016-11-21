import UIKit
import Unbox

public enum PhotoSize {
    case full
    case raw
    case regular
    case small
    case thumb
}

public class URLs: NSObject, Unboxable {
    
    public let full: URL
    public let raw: URL
    public let regular: URL
    public let small: URL
    public let thumb: URL
    
    required init(unboxer: Unboxer) throws {
        self.full = try unboxer.unbox(key: "full")
        self.raw = try unboxer.unbox(key: "raw")
        self.regular = try unboxer.unbox(key: "regular")
        self.small = try unboxer.unbox(key: "small")
        self.thumb = try unboxer.unbox(key: "thumb")
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
