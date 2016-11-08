typealias PListDictionary = [String: AnyObject]
protocol PlistKey: RawRepresentable {}

protocol PlistValue {}
extension String: PlistValue {}
extension Date: PlistValue {}

extension Dictionary where Value: AnyObject {
    func value<V: PlistValue, K: PlistKey>(forKey key: K) -> V where K.RawValue == String {
        return self[key.rawValue as! Key] as! V
    }
}
