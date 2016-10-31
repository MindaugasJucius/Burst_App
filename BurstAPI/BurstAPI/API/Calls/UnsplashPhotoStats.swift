import Alamofire
import Unbox

public typealias StatsCallback = (_ photos: Stats?, _ error: Error?) -> ()

public class UnsplashPhotoStats: NSObject {

    public static func stats(forPhoto photo: Photo, completion completionHandler: @escaping StatsCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let statsURL = String(format: UnsplashPhotoStatsURL, photo.id)
        let params = [BurstID : appID] as [String : Any]
        Alamofire.request(statsURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let statsJSON = value as? NSDictionary else { return }
                UnboxSerializer.parse(response: statsJSON,
                    success: { (photoStats: Stats) in
                        completionHandler(photoStats, .none)
                    },
                    failure: { error in
                        completionHandler(.none, error)
                    }
                )
            case .failure(let error):
                completionHandler(.none, error as NSError)
            }
        }
    }
}
