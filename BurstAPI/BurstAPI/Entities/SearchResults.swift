import Unbox

public class SearchResults<U>: NSObject, Unboxable {

    public let total: Int
    public let totalPages: Int
    public let results: [U]
    
    required public init(unboxer: Unboxer) throws {
        self.total = try unboxer.unbox(key: "total")
        self.totalPages = try unboxer.unbox(key: "total_pages")
        self.results = try unboxer.unbox(key: "results")
        super.init()
    }
    
}
