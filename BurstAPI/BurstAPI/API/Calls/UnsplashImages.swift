import AlamofireImage
import Alamofire

public typealias ProgressCallback = (_ progress: Double) -> ()
public typealias ImageCallback = (_ image: UIImage) -> ()
public typealias PhotoDownloadCallback = (_ response: DataResponse<UIImage>) -> ()

public class UnsplashImages: NSObject {

    public static let fullImageDownloader = ImageDownloader(
        configuration: config(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 1,
        imageCache: nil
    )
    
    public static let thumbImageDownloader = ImageDownloader(
        downloadPrioritization: .lifo,
        maximumActiveDownloads: 10
    )
    
    public static let cellImageDownloader = ImageDownloader(
        configuration: config(),
        downloadPrioritization: .lifo,
        maximumActiveDownloads: 4,
        imageCache: nil
    )
    
    private static func config() -> URLSessionConfiguration {
        let config = ImageDownloader.defaultURLSessionConfiguration()
        config.urlCache = nil
        return config
    }
    
    public static func image(fromUrl url: URL,
               withDownloader downloader: ImageDownloader,
               progressHandler: ProgressCallback?,
               success: @escaping ImageCallback,
               failure: @escaping ErrorCallback) {
        let request = URLRequest(url: url)
        downloader.download(
            request,
            progress: { progress in
                progressHandler?(progress.fractionCompleted)
            },
            completion: { response in
                switch response.result {
                case .success(let image):
                    success(image)
                case .failure(let error):
                    failure(error)
                }
            }
        )
    }
}
