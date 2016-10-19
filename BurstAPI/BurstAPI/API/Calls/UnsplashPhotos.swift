import UIKit
import Alamofire
import AlamofireImage
import Unbox

public typealias PhotosCallback = (_ photos: [Photo]?, _ error: NSError?) -> ()
public typealias StatsCallback = (_ photos: Stats?, _ error: NSError?) -> ()
public typealias EmptyCallback = () -> ()
public typealias ProgressCallback = (_ progress: Double) -> ()
public typealias PhotoDownloadCallback = (_ response: DataResponse<UIImage>, _ photo: Photo) -> ()

open class UnsplashPhotos: NSObject {
    
    public static let defaultInstance = UnsplashPhotos()
    
    private let networkGroup = DispatchGroup()
    private let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .fifo, maximumActiveDownloads: 1)

    public func getPhotos(_ page: Int, completion completionHandler: @escaping PhotosCallback) {
        guard let appID = AppConstants.appConstDict[BurstID] else { return }
        let params = [BurstID : appID,
                      "page": String(page)] as [String : Any]
        Alamofire.request(UnsplashPhotosAllURL, method: .get, parameters: params).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                guard let photosJSON = value as? NSArray else { return }
                guard let strongSelf = self else { return }
                strongSelf.parsePhotoEntities(photosJSON, completionCallback: completionHandler)
            case .failure(let error):
                completionHandler(.none, error as NSError)
            }
        }
    }
    
    private func parsePhotoEntities(_ photosJSON: NSArray, completionCallback: @escaping PhotosCallback) {
        do {
            var photos = [Photo]()
            try photosJSON.forEach({ (photoJSON) in
                guard let photo = photoJSON as? UnboxableDictionary else { return }
                let parsedPhoto: Photo = try unbox(dictionary: photo)
                networkGroup.enter()
                getPhotoImage(parsedPhoto.urls.small as URL, callback: { [weak self] (image, error) in
                    guard let strongSelf = self else { return }
                    guard let image = image else { return }
                    parsedPhoto.thumbImage = image
                    photos.append(parsedPhoto)
                    UnsplashPhotoStats.getPhotoStats(forPhoto: parsedPhoto, completion: { stats, error in
                            guard let stats = stats else {
                                strongSelf.networkGroup.leave()
                                return
                            }
                            parsedPhoto.stats = stats
                            strongSelf.networkGroup.leave()
                        }
                    )
                })
            })
            networkGroup.notify(queue: DispatchQueue.main, execute: {
                completionCallback(photos, .none)
            })
        } catch let error {
            completionCallback(.none, error as NSError)
        }
    }
    
    private func getPhotoImage(_ urlRequest: URL, callback: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        let request = URLRequest(url: urlRequest)
        imageDownloader.download(request) { response in
            switch response.result {
            case .success(let image):
                callback(image, .none)
            case .failure(let error):
                callback(.none, error)
            }
        }
    }
    
    public func addImageToQueueForDownload(_ photo: Photo, progressHandler: @escaping ProgressCallback, completion: @escaping PhotoDownloadCallback) {
        let request = URLRequest(url: photo.urls.full)
        imageDownloader.download(request,
            progress: { progress in
                progressHandler(progress.fractionCompleted)
            },
            completion: { response in
                completion(response, photo)
            }
        )
    }
    
}
