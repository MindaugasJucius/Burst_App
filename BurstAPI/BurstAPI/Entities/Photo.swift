import UIKit
import Unbox

open class Photo: NSObject, Unboxable {

    open let id: String
    open let likes: NSInteger
    //open let downloads: Int
    open let urls: URLs
    open let uploader: User
    open let fullSize: CGSize
    open let categories: [PhotoCategory]?
    open let color: UIColor
     
    open var thumbImage: UIImage?
    open var stats: Stats?
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.urls = try unboxer.unbox(key: "urls")
        self.likes = try unboxer.unbox(key: "likes")
        self.uploader = try unboxer.unbox(key: "user")
        self.categories = unboxer.unbox(key: "categories")
        let hexString: String = try unboxer.unbox(key: "color")
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = try unboxer.unbox(key: "height")
        let width: CGFloat = try unboxer.unbox(key: "width")
        //self.downloads = try unboxer.unbox(key: "downloads")
        self.fullSize = CGSize(width: width, height: height)
        super.init()
    }
    
//    public init(id: String, urls: URLs, likes: NSInteger, user: User, categories: [PhotoCategory]?, color: String, height: CGFloat, width: CGFloat) {
//        self.id = id
//        self.urls = urls
//        self.likes = likes
//        self.uploader = user
//        self.categories = categories
//        let hexString: String = color
//        self.color = UIColor.colorWithHexString(hexString)
//        let height: CGFloat = height
//        let width: CGFloat = width
//        self.fullSize = CGSize(width: width, height: height)
//        super.init()
//    }
    
}
