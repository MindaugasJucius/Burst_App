import Unbox

public class User: NSObject, Unboxable {

    public let id: String
    public let name: String
    public let portfolioURL: String?
    public let username: String
    public let userProfileImage: UserProfileImage
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.portfolioURL = unboxer.unbox(key: "portfolio_url")
        self.username = try unboxer.unbox(key: "username")
        self.userProfileImage = try unboxer.unbox(key: "profile_image")
        super.init()
    }
    
}
