import Alamofire

public typealias PhotoCallback = (_ photo: Photo) -> ()

public class UnsplashPhoto: NSObject {

    public static func photo(withID id: String,
               success: @escaping PhotoCallback,
               failure: @escaping ErrorCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let singlePhotoURL = String(format: UnsplashSinglePhotoURL, id)
        let params = [BurstID : appID] as [String : Any]
        Alamofire.request(singlePhotoURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                dump(String(describing: value))
                guard let photoJSON = value as? NSDictionary else { return }
                UnboxSerializer.parse(response: photoJSON,
                    success: { (photo: Photo) in
                        success(photo)
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
