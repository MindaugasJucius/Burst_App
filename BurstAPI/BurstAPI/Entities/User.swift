import Unbox

public class User: NSObject, Unboxable {

    public let id: String
    public let name: String
    public let portfolioURL: String?
    public let username: String
    
    required public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        self.portfolioURL = unboxer.unbox("portfolio_url")
        self.username = unboxer.unbox("username")
    }
    
    public init(id: String, name: String, portfolioURL: String?, username: String) {
        self.id = id
        self.name = name
        self.portfolioURL = portfolioURL
        self.username = username
        super.init()
    }
}
