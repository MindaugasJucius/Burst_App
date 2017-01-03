// MARK: - API urls

public let UnsplashSinglePhotoURL = "https://api.unsplash.com/photos/%@"
public let UnsplashPhotosAllURL = "https://api.unsplash.com/photos/"
public let UnsplashPhotoStatsURL = "https://api.unsplash.com/photos/%@/stats"
public let UnsplashCuratedPhotosURL = "https://api.unsplash.com/photos/curated"
public let UnsplashSearchPhotosURL = "https://api.unsplash.com/search/photos/"
public let UnsplashUsersCollections = "https://api.unsplash.com/users/%@/collections"

// MARK: - key constants

public enum QueryParams: String {
    
    case burstID = "client_id"
    case contentPage = "page"
    case searchQuery = "query"
    
    public static var appId: String {
        get {
            return "5199065860e72b9242b2d3195d43708c51b63a521ca9f27596ea3c7056c78274"
        }
    }
    
}
