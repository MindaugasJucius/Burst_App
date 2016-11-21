import Unbox

class Collection: NSObject, Unboxable {
    
    let id: String
    let title: String
    let collectionDescription: String
    let curated: Bool
    let photosCount: Int
    let privateCollection: Bool
    let shareKey: String
    let coverPhoto: Photo
    let collectionOwner: User
    
    required init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.title = try unboxer.unbox(key: "title")
        self.collectionDescription = try unboxer.unbox(key: "description")
        self.curated = try unboxer.unbox(key: "curated")
        self.photosCount = try unboxer.unbox(key: "total_photos")
        self.privateCollection = try unboxer.unbox(key: "private")
        self.shareKey = try unboxer.unbox(key: "share_key")
        self.coverPhoto = try unboxer.unbox(key: "cover_photo")
        self.collectionOwner = try unboxer.unbox(key: "user")
        super.init()
    }
}
