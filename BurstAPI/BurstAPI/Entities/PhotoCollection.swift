import Unbox

public class PhotoCollection: NSObject, Unboxable {
    
    public let id: String
    public let title: String
    public let collectionDescription: String?
    public let curated: Bool
    public let photosCount: Int
    public let privateCollection: Bool
    public let shareKey: String
    public let coverPhoto: Photo?
    public let collectionOwner: User
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.title = try unboxer.unbox(key: "title")
        self.collectionDescription = unboxer.unbox(key: "description")
        self.curated = try unboxer.unbox(key: "curated")
        self.photosCount = try unboxer.unbox(key: "total_photos")
        self.privateCollection = try unboxer.unbox(key: "private")
        self.shareKey = try unboxer.unbox(key: "share_key")
        self.coverPhoto = unboxer.unbox(key: "cover_photo")
        self.collectionOwner = try unboxer.unbox(key: "user")
        super.init()
    }
}
