import UIKit
import Unbox

public typealias EntitiesCallback<U: Unboxable> = (_ entities: [U]) -> ()
public typealias EntityCallback<U: Unboxable> = (_ entity: U) -> ()
public typealias ErrorCallback = (NSError) -> ()

class UnboxSerializer: NSObject {

    static func parse<U: Unboxable>(_ response: UnboxableDictionary, success: @escaping EntityCallback<U>, failure: @escaping ErrorCallback) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let parsedEntity: U = try unbox(dictionary: response)
                DispatchQueue.main.async {
                    success(parsedEntity)
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
    
    
}
