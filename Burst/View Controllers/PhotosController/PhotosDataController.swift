import BurstAPI

fileprivate let InitialPageIndex = 1

class PhotosDataController: NSObject {

    private var currentPage = InitialPageIndex
    
    func resetState() {
        currentPage = InitialPageIndex
    }
    
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
    
}
