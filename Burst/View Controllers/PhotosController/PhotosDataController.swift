import BurstAPI

class PhotosDataController: NSObject {

    private var currentPage = 1
    
    func fetchPhotos(fromURL: URL, success: @escaping EntityArrayCallback<Photo>, error: @escaping ErrorCallback) {
        let params = ["page": String(currentPage)]
        UnsplashGeneric.unsplashArray(
            getFromURL: URL(string: UnsplashPhotosAllURL),
            queryParams: params,
            success: { [unowned self] (photos: [Photo]) in
                success(photos)
                self.currentPage += 1
            },
            failure: error
        )
    }
    
    func fetchImages(forPhotos: [Photo]) {
        
    }
    
}
