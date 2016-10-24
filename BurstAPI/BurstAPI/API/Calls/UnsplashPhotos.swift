import Alamofire

public typealias PhotosCallback = (_ photos: [Photo]) -> ()
public typealias EmptyCallback = () -> ()

public class UnsplashPhotos: NSObject {

    public static func photos(forPage page: Int,
                              success: @escaping PhotosCallback,
                              failure: @escaping ErrorCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let params = [BurstID : appID, "page": String(page), "per_page": 5] as [String : Any]
        Alamofire.request(UnsplashPhotosAllURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let photosJSON = value as? [NSDictionary] else { return }
                UnboxSerializer.parse(responses: photosJSON,
                    success: { (photos: [Photo]) in
                        success(photos)
                    },
                    failure: { error in
                        failure(error)
                    }
                )
            case .failure(let error):
                failure(error)
            }
        }
    }
}
