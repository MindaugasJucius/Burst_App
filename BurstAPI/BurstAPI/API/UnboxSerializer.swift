import UIKit
import Unbox

public typealias EntitiesCallback<U: Unboxable> = (_ entities: [U]) -> ()
public typealias EntityCallback<U: Unboxable> = (_ entity: U) -> ()
public typealias ErrorCallback = (NSError) -> ()

class UnboxSerializer: NSObject {
    
    static func parse<U: Unboxable>(response: NSDictionary, success: @escaping EntityCallback<U>, failure: @escaping ErrorCallback) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let unboxDictionary = response as? UnboxableDictionary else {
                    let error = NSError(domain: "Unable to parse model: \(String(describing: U.self))", code: 0, userInfo: nil)
                    failure(error)
                    return
                }
                let parsedEntity: U = try unbox(dictionary: unboxDictionary)
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
    
    static func parse<U: Unboxable>(responses: [NSDictionary], success: @escaping EntitiesCallback<U>, failure: @escaping ErrorCallback) {
        let parseGroup = DispatchGroup()
        var parsedArray: [U] = []
        
        responses.forEach { response in
            parseGroup.enter()
            UnboxSerializer.parse(response: response,
                success: { (serialized: U) in
                    parsedArray.append(serialized)
                    parseGroup.leave()
                },
                failure: { error in
                    parseGroup.leave()
                    parseGroup.notify(queue: DispatchQueue.main,
                        execute: {
                            failure(error)
                        }
                    )
                }
            )
        }
        parseGroup.notify(queue: DispatchQueue.main,
            execute: {
                success(parsedArray)
            }
        )
    }
    
}
