import Unbox

open class PhotoCategoryLinks: NSObject, Unboxable {
    
    open let photos: URL
    open let linkToSelf: URL
    
    required public init(unboxer: Unboxer) throws {
        self.photos = try unboxer.unbox(key: "photos")
        self.linkToSelf = try unboxer.unbox(key: "self")
    }

}

open class PhotoCategory: NSObject, Unboxable {
    
    open let id: Int
    open let photoCount: Int
    open let categoryTitle: String
    open let links: PhotoCategoryLinks
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.links = try unboxer.unbox(key: "links")
        self.photoCount = try unboxer.unbox(key:"photo_count")
        self.categoryTitle = try unboxer.unbox(key: "title")
        super.init()
    }
    
}
