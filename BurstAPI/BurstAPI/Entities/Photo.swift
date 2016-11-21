import UIKit
import Unbox

public enum PhotoInfoType {
    case author
    case location
    case exif
    case categories
}

public class Photo: NSObject, Unboxable {

    // Available on ever photo returning call
    public let id: String
    public let likes: NSInteger
    public let urls: URLs
    public let uploader: User
    public let fullSize: CGSize
    public let color: UIColor
    public let likedByUser: Bool
    
    // Available only retrieving a single photo
    public let categories: [PhotoCategory]?
    public let location: Location?
    public let exif: EXIF?
    public let downloads: Int?
    
    public var thumbImage: UIImage?
    public var smallImage: UIImage?
    public var stats: Stats?
    
    public var presentationImage: UIImage? {
        get {
            guard let small = smallImage else {
                return thumbImage
            }
            return small
        }
    }
    
    required init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.urls = try unboxer.unbox(key: "urls")
        self.likes = try unboxer.unbox(key: "likes")
        self.likedByUser = try unboxer.unbox(key: "liked_by_user")
        self.downloads = unboxer.unbox(key: "downloads")
        self.uploader = try unboxer.unbox(key: "user")
        self.location = unboxer.unbox(key: "location")
        self.exif = unboxer.unbox(key: "exif")
        self.categories = unboxer.unbox(key: "categories")
        let hexString: String = try unboxer.unbox(key: "color")
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = try unboxer.unbox(key: "height")
        let width: CGFloat = try unboxer.unbox(key: "width")
        self.fullSize = CGSize(width: width, height: height)
        super.init()
    }
    
    public func checkForAvailableInfo() -> [PhotoInfoType] {
        var availableInfo: [PhotoInfoType] = []
        availableInfo.append(.author)
        if location != nil {
            availableInfo.append(.location)
        }
        if exif != nil {
            availableInfo.append(.exif)
        }
        if categories != nil {
            availableInfo.append(.categories)
        }
        return availableInfo
    }
    
}
