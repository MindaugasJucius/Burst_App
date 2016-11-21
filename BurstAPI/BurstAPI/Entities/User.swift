import Unbox

public class UserProfileLinks: NSObject, Unboxable {
    
    public let profile: URL
    public let photos: URL
    public let likes: URL
    public let portfolio: URL
    public let followers: URL
    public let following: URL
    
    required public init(unboxer: Unboxer) throws {
        self.followers = try unboxer.unbox(key: "followers")
        self.following = try unboxer.unbox(key: "following")
        self.profile = try unboxer.unbox(key: "self")
        self.photos = try unboxer.unbox(key: "photos")
        self.likes = try unboxer.unbox(key: "likes")
        self.portfolio = try unboxer.unbox(key: "portfolio")
    }
}

public class User: NSObject, Unboxable {

    public let id: String
    public let name: String
    public let portfolioURL: String?
    public let username: String
    public let bio: String?
    public let location: String?
    
    public let totalLikes: Int?
    public let totalPhotos: Int?
    public let totalCollections: Int?
    public let totalDownloads: Int?
    
    public let followedByUser: Bool?
    public let followersCount: Int?
    public let followingCount: Int?
    
    public let userProfileImage: UserProfileImage
    public let userProfileLinks: UserProfileLinks
    public let usersCollectionsLink: URL?
    
    required public init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.location = unboxer.unbox(key: "location")
        self.followedByUser = unboxer.unbox(key: "followed_by_user")
        self.followersCount = unboxer.unbox(key: "followers_count")
        self.followingCount = unboxer.unbox(key: "following_count")
        self.totalLikes = unboxer.unbox(key: "total_likes")
        self.totalPhotos = unboxer.unbox(key: "total_photos")
        self.totalCollections = unboxer.unbox(key: "total_collections")
        self.totalDownloads = unboxer.unbox(key: "downloads")
        self.bio = unboxer.unbox(key: "bio")
        self.name = try unboxer.unbox(key: "name")
        self.portfolioURL = unboxer.unbox(key: "portfolio_url")
        self.username = try unboxer.unbox(key: "username")
        self.userProfileImage = try unboxer.unbox(key: "profile_image")
        self.userProfileLinks = try unboxer.unbox(key: "links")
        if let totalCollectionsCount = totalCollections, totalCollectionsCount > 0 {
            usersCollectionsLink = URL(string: String(format: UnsplashUsersCollections, username))
        } else {
            usersCollectionsLink = nil
        }
        super.init()
    }
    
}
