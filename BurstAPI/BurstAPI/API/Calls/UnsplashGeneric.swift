import Alamofire
import Unbox

public typealias SingleEntityCallback<U: Unboxable> = (_ unboxableEntity: U) -> ()
public typealias EntityArrayCallback<U: Unboxable> = (_ unboxableArray: [U]) -> ()

public class UnsplashGeneric: NSObject {

    public static func unsplash<U: Unboxable>(getFromURL url: URL,
                             success: @escaping SingleEntityCallback<U>,
                             failure: ErrorCallback?) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let params = [BurstID : appID] as [String : Any]
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
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
    
    public static func unsplashArray<U: Unboxable>(getFromURL url: URL,
                                success: @escaping EntityArrayCallback<U>,
                                failure: ErrorCallback?) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let params = [BurstID : appID] as [String : Any]
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
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
}
