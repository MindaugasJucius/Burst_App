import Alamofire

public typealias PhotosCallback = (_ photos: [Photo]?, _ error: Error?) -> ()
public typealias EmptyCallback = () -> ()

public class UnsplashPhotos: NSObject {

    public static func photos(forPage page: Int, completion completionHandler: @escaping PhotosCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let params = [BurstID : appID, "page": String(page), "per_page": 10] as [String : Any]
        Alamofire.request(UnsplashPhotosAllURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let photosJSON = value as? [NSDictionary] else { return }
                UnboxSerializer.parse(responses: photosJSON,
                    success: { (photos: [Photo]) in
                        completionHandler(photos, .none)
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
