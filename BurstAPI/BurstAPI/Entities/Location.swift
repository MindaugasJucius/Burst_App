import Unbox

public class Position: NSObject, Unboxable {
    
    public let latitude: Double
    public let longitude: Double
    
    required public init(unboxer: Unboxer) throws {
        self.latitude = try unboxer.unbox(key: "latitude")
        self.longitude = try unboxer.unbox(key: "longitude")
        super.init()
    }
}

public class Location: NSObject, Unboxable {
    
    public let city: String
    public let country: String
    public let position: Position

    public var fullLocation: String {
        return "\(city), \(country)"
    }
    
    required public init(unboxer: Unboxer) throws {
        self.city = try unboxer.unbox(key: "city")
        self.country = try unboxer.unbox(key: "country")
        self.position = try unboxer.unbox(key: "position")
        super.init()
    }
    
}
