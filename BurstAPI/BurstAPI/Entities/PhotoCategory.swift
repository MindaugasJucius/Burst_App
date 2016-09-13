import Unbox

public class PhotoCategoryLinks: NSObject, Unboxable {
    
    public let photos: NSURL
    public let linkToSelf: NSURL //wtf is this?
    
    required public init(unboxer: Unboxer) {
        self.photos = unboxer.unbox("photos")
        self.linkToSelf = unboxer.unbox("self")
    }

}

public class PhotoCategory: NSObject, Unboxable {
    
    public let id: Int
    public let photoCount: Int
    public let categoryTitle: String
    public let links: PhotoCategoryLinks
    
    required public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.links = unboxer.unbox("links")
        self.photoCount = unboxer.unbox("photo_count")
        self.categoryTitle = unboxer.unbox("title")
        super.init()
    }
    
}
