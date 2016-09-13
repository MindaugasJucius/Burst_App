import UIKit
import Unbox

public class Photo: NSObject, Unboxable {

    public let id: String
    public let likes: NSInteger
    public let urls: URLs
    public let uploader: User
    public let fullSize: CGSize
    public let categories: [PhotoCategory]?
    public let color: UIColor
     
    public var thumbImage: UIImage?
    
    required public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.urls = unboxer.unbox("urls")
        self.likes = unboxer.unbox("likes")
        self.uploader = unboxer.unbox("user")
        self.categories = unboxer.unbox("categories")
        let hexString: String = unboxer.unbox("color")
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = unboxer.unbox("height")
        let width: CGFloat = unboxer.unbox("width")
        self.fullSize = CGSizeMake(width, height)
    }
    
    public init(id: String, urls: URLs, likes: NSInteger, user: User, categories: [PhotoCategory]?, color: String, height: CGFloat, width: CGFloat) {
        self.id = id
        self.urls = urls
        self.likes = likes
        self.uploader = user
        self.categories = categories
        let hexString: String = color
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = height
        let width: CGFloat = width
        self.fullSize = CGSizeMake(width, height)
        super.init()
    }
    
}
