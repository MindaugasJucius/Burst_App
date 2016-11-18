import Unbox

public class EXIF: NSObject, Unboxable {

    public let madeBy: String
    public let model: String
    public let exposureTime: Double
    public let aperture: Double
    public let focalLength: Double
    public let iso: Int

    
    required public init(unboxer: Unboxer) throws {
        self.madeBy = try unboxer.unbox(key: "make")
        self.model = try unboxer.unbox(key: "model")
        self.exposureTime = try unboxer.unbox(key: "exposure_time")
        self.aperture = try unboxer.unbox(key: "aperture")
        self.focalLength = try unboxer.unbox(key: "focal_length")
        self.iso = try unboxer.unbox(key: "iso")
        super.init()
    }
    
}
