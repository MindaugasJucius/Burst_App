import UIKit
import Alamofire
import AlamofireImage
import Unbox

public typealias PhotosCallback = (_ photos: [Photo]?, _ error: NSError?) -> ()
public typealias EmptyCallback = () -> ()
public typealias ProgressCallback = (_ progress: Progress) -> ()
public typealias PhotoDownloadCallback = (_ response: DataResponse<UIImage>, _ photo: Photo) -> ()

open class UnsplashPhotos: NSObject {
    
    open static let defaultInstance = UnsplashPhotos()
    
    fileprivate let networkGroup = DispatchGroup()
    fileprivate let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .fifo, maximumActiveDownloads: 1)

    open func getPhotos(_ completionHandler: @escaping PhotosCallback, page: Int) -> [Photo]? {
        guard let appID = AppConstants.appConstDict[BurstID] else { return .none }
        Alamofire.request(UnsplashPhotosAll, method: .get, parameters: [BurstID : appID, "page": String(page)]).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                guard let photosJSON = value as? NSArray else { return }
                guard let strongSelf = self else { return }
                strongSelf.parsePhotoEntities(photosJSON, completionCallback: completionHandler)
            case .failure(let error):
                completionHandler(.none, error as NSError)
            }
        }
        return .none
    }
    
    fileprivate func parsePhotoEntities(_ photosJSON: NSArray, completionCallback: @escaping PhotosCallback) {
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
                    strongSelf.networkGroup.leave()
                })
            })
            networkGroup.notify(queue: DispatchQueue.main, execute: {
                completionCallback(photos, .none)
            })
        } catch let error {
            completionCallback(.none, error as NSError)
        }
    }
    
    fileprivate func getPhotoImage(_ urlRequest: URL, callback: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        let request = URLRequest(url: urlRequest)
        ImageDownloader.default.download(request) { response in
            switch response.result {
            case .success(let image):
                callback(image, .none)
            case .failure(let error):
                callback(.none, error)
            }
        }
    }
    
    open func addImageToQueueForDownload(_ photo: Photo, progressHandler: @escaping ProgressCallback, completion: @escaping PhotoDownloadCallback) {
    
//        filter: ImageFilter? = nil,
//        progress: ProgressHandler? = nil,
//        progressQueue: DispatchQueue = DispatchQueue.main,
//        completion: CompletionHandler?
        let request = URLRequest(url: photo.urls.full)
        imageDownloader.download(request, progress:
            { progress in
//                let progress = Float(totalBytesRead) / Float(totalExpectedBytesToRead)
//                progressHandler(progress: progress)
            },
            completion: { response in
                completion(response, photo)
            }
        )
    }
    
}
