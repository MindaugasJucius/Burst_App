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
    open var smallImage: UIImage?
    open var stats: Stats?
    
    public var presentationImage: UIImage? {
        get {
            guard let small = smallImage else {
                return thumbImage
            }
            return small
        }
    }
    
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
        self.fullSize = CGSize(width: width, height: height)
        super.init()
    }

}
