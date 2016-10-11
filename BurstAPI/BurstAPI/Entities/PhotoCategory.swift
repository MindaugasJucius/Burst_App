import Unbox

open class PhotoCategoryLinks: NSObject, Unboxable {
    
    open let photos: URL
    open let linkToSelf: URL //wtf is this?
    
    required public init(unboxer: Unboxer) {
        self.photos = unboxer.unbox("photos")
        self.linkToSelf = unboxer.unbox("self")
    }

}

open class PhotoCategory: NSObject, Unboxable {
    
    open let id: Int
    open let photoCount: Int
    open let categoryTitle: String
    open let links: PhotoCategoryLinks
    
    required public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.links = unboxer.unbox("links")
        self.photoCount = unboxer.unbox("photo_count")
        self.categoryTitle = unboxer.unbox("title")
        super.init()
    }
    
}
