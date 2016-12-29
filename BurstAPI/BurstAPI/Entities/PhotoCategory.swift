import Unbox

public class PhotoCategoryLinks: NSObject, Unboxable {
    
    public let photos: URL
    public let linkToSelf: URL
    
    required public init(unboxer: Unboxer) throws {
        self.photos = try unboxer.unbox(key: "photos")
        self.linkToSelf = try unboxer.unbox(key: "self")
    }

}

public struct PhotoCategory: Unboxable {
    
    public let id: Int
    public let photoCount: Int
    public let categoryTitle: String
    public let links: PhotoCategoryLinks
    
    public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.links = try unboxer.unbox(key: "links")
        self.photoCount = try unboxer.unbox(key:"photo_count")
        self.categoryTitle = try unboxer.unbox(key: "title")
    }
    
}
