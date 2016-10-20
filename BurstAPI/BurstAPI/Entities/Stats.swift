import Unbox

open class Stats: NSObject, Unboxable {

    open let downloads: Int
    open let likes: Int
    open let views: Int
    
    //TODO: let links
    
    required public init(unboxer: Unboxer) throws {
        self.downloads = try unboxer.unbox(key: "downloads")
        self.likes = try unboxer.unbox(key: "likes")
        self.views = try unboxer.unbox(key: "views")
        super.init()
    }
}