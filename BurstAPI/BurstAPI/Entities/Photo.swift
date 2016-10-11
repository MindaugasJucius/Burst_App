import UIKit
import Unbox

open class Photo: NSObject, Unboxable {

    open let id: String
    open let likes: NSInteger
    open let urls: URLs
    open let uploader: User
    open let fullSize: CGSize
    open let categories: [PhotoCategory]?
    open let color: UIColor
     
    open var thumbImage: UIImage?
    
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
        self.fullSize = CGSize(width: width, height: height)
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
        self.fullSize = CGSize(width: width, height: height)
        super.init()
    }
    
}
