import Alamofire
import Unbox

public typealias SingleEntityCallback<U: Unboxable> = (_ unboxableEntity: U) -> ()
public typealias EntityArrayCallback<U: Unboxable> = (_ unboxableArray: [U]) -> ()
public typealias EmptyCallback = () -> ()
public typealias ParamsDict = [String: Any]

public class UnsplashGeneric: NSObject {

    public static func unsplash<U: Unboxable>(getFromURL url: URL?,
                                queryParams: ParamsDict? = nil,
                                success: @escaping SingleEntityCallback<U>,
                                failure: ErrorCallback?) {
        guard let queryURL = url else {
            return
        }
        let parameters = paramsDict(additionalValues: queryParams)
        Alamofire.request(queryURL, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let responseJSON = value as? NSDictionary else { return }
                UnboxSerializer.parse(response: responseJSON,
                    success: { (response: U) in
                        success(response)
                    },
                    failure: { error in
                        failure?(error)
                    }
                )
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public static func unsplashArray<U: Unboxable>(getFromURL url: URL?,
                                     queryParams: [String: Any]? = nil,
                                     success: @escaping EntityArrayCallback<U>,
                                     failure: ErrorCallback?) {
        guard let queryURL = url else {
            return
        }
        let parameters = paramsDict(additionalValues: queryParams)
        Alamofire.request(queryURL, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let responseJSON = value as? [NSDictionary] else { return }
                UnboxSerializer.parse(responses: responseJSON,
                    success: { (response: [U]) in
                        success(response)
                    },
                    failure: { error in
                        failure?(error)
                    }
                )
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    private static func paramsDict(additionalValues: ParamsDict?) -> ParamsDict {
        var params = [QueryParams.burstID.rawValue :
            QueryParams.appId] as ParamsDict
        guard let additionalDict = additionalValues else {
            return params
        }
        for key in additionalDict.keys {
            guard let value = additionalDict[key] else { continue }
            params.updateValue(value, forKey: key)
        }
        return params
    }
}
