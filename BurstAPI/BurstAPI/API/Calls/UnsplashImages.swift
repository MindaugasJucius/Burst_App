import AlamofireImage
import Alamofire

public typealias ProgressCallback = (_ progress: Double) -> ()
public typealias PhotoDownloadCallback = (_ response: DataResponse<UIImage>, _ photo: Photo) -> ()

public class UnsplashImages: NSObject {

    private static let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 1
    )

    public static func getPhotoImage(_ urlRequest: URL, callback: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
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

    public static func addImageToQueueForDownload(_ photo: Photo, progressHandler: @escaping ProgressCallback, completion: @escaping PhotoDownloadCallback) {
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
