import Alamofire
import Unbox

class UnsplashPhotoStats: NSObject {

    static func getPhotoStats(forPhoto photo: Photo, completion completionHandler: @escaping StatsCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let statsURL = String(format: UnsplashPhotoStatsURL, photo.id)
        let params = [BurstID : appID] as [String : Any]
        Alamofire.request(statsURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let statsDict = value as? UnboxableDictionary else { return }
                do {
                    let stats: Stats = try unbox(dictionary: statsDict)
                    completionHandler(stats, .none)
                } catch let error as NSError {
                    completionHandler(.none, error)
                }
            case .failure(let error):
                completionHandler(.none, error as NSError)
            }
        }
    }
}
