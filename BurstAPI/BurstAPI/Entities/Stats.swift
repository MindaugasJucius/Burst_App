import Unbox

public class Stats: NSObject, Unboxable {

    public let downloads: Int
    public let likes: Int
    public let views: Int
    
    //TODO: let links
    
    required init(unboxer: Unboxer) throws {
        self.downloads = try unboxer.unbox(key: "downloads")
        self.likes = try unboxer.unbox(key: "likes")
        self.views = try unboxer.unbox(key: "views")
        super.init()
    }
}
