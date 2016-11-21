import UIKit

class Collection: NSObject, Unboxable {
    
    
    "id": 296,
    "title": "I like a man with a beard.",
    "description": "Yeah even Santa...",
    "published_at": "2016-01-27T18:47:13-05:00",
    "curated": false,
    "total_photos": 12,
    "private": false,
    "share_key": "312d188df257b957f8b86d2ce20e4766",
    
    required init(unboxer: Unboxer) throws {
        self.latitude = try unboxer.unbox(key: "latitude")
        self.longitude = try unboxer.unbox(key: "longitude")
        super.init()
    }
}
