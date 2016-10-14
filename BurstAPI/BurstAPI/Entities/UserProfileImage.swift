import Unbox

open class UserProfileImage: NSObject, Unboxable {
    
    open let small: String
    open let medium: String
    open let large: String
    
    required public init(unboxer: Unboxer) throws {
        self.small = try unboxer.unbox(key: "small")
        self.medium = try unboxer.unbox(key: "medium")
        self.large = try unboxer.unbox(key: "large")
    }
}
