import Unbox

public class UserProfileImage: NSObject, Unboxable {
    
    public let small: URL
    public let medium: URL
    public let large: URL
    
    required init(unboxer: Unboxer) throws {
        self.small = try unboxer.unbox(key: "small")
        self.medium = try unboxer.unbox(key: "medium")
        self.large = try unboxer.unbox(key: "large")
    }
}
