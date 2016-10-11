import Unbox

open class User: NSObject, Unboxable {

    open let id: String
    open let name: String
    open let portfolioURL: String?
    open let username: String
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.portfolioURL = unboxer.unbox(key: "portfolio_url")
        self.username = try unboxer.unbox(key: "username")
    }
    
    public init(id: String, name: String, portfolioURL: String?, username: String) {
        self.id = id
        self.name = name
        self.portfolioURL = portfolioURL
        self.username = username
        super.init()
    }
}
