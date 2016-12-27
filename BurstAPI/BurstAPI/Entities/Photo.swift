import UIKit
import Unbox

public enum PhotoInfoType {
    case author
    case location
    case exif
    case categories
}

public enum PhotoSize: String {
    case full
    case raw
    case regular
    case small
    case thumb

    static var allValues: [PhotoSize] {
        return [.full, .raw, .regular, .small, .thumb]
    }
    
}

public class Photo: NSObject, Unboxable {

    // Available on every photo returning call
    public let id: String
    public let likes: NSInteger
    public let donwloadURLs: [PhotoSize: URL]
    public let uploader: User
    public let fullSize: CGSize
    public let color: UIColor
    public let likedByUser: Bool
    
    // Available only when retrieving a single photo
    public let categories: [PhotoCategory]?
    public let location: Location?
    public let exif: EXIF?
    public let downloads: Int?
    
    public weak var thumbImage: UIImage?
    public weak var smallImage: UIImage?
    public var stats: Stats?
    
    public var presentationImage: UIImage? {
        get {
            return smallImage ?? thumbImage
        }
    }
    
    required public init(unboxer: Unboxer) throws {
        let id: String = try unboxer.unbox(key: "id")
        self.id = id
        print(id)
        self.donwloadURLs = try Photo.sizes(fromUnboxer: unboxer)
        self.likes = try unboxer.unbox(key: "likes")
        self.likedByUser = try unboxer.unbox(key: "liked_by_user")
        self.downloads = unboxer.unbox(key: "downloads")
        self.uploader = try unboxer.unbox(key: "user")
        self.location = unboxer.unbox(key: "location")
        self.exif = unboxer.unbox(key: "exif")
        let photoCategories: [PhotoCategory]? = unboxer.unbox(key: "categories")
        self.categories = photoCategories?.count != 0 ? photoCategories : nil
        let hexString: String = try unboxer.unbox(key: "color")
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = try unboxer.unbox(key: "height")
        let width: CGFloat = try unboxer.unbox(key: "width")
        self.fullSize = CGSize(width: width, height: height)
        super.init()
    }
    
    public func url(forSize size: PhotoSize) -> URL {
        return donwloadURLs[size]!
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
    
    private static func sizes(fromUnboxer unboxer: Unboxer) throws -> [PhotoSize: URL] {
        var sizesDict: [PhotoSize: URL] = [:]
        try PhotoSize.allValues.forEach {
            let url: URL = try unboxer.unbox(keyPath: "urls.\($0.rawValue)")
            sizesDict[$0] = url
        }
        return sizesDict
    }
    
}
