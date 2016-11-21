import BurstAPI

typealias CorrespondingInfoControllers = [PhotoInfoType: UIViewController]
typealias PhotoInfoCallback = (_ photo: Photo, _ infoControllers: CorrespondingInfoControllers) -> ()

extension PhotoInfoType {
    
    var controllerTypeForInfo: UIViewController.Type? {
        switch self {
        case .author:
            return AuthorViewController.self
        default:
            return nil
        }
    }
    
    var controllerForInfo: UIViewController? {
        return controllerTypeForInfo?.fromStoryboard()
    }
    
}

class PhotoDataController: NSObject {

    var infoControllers: [UIViewController]?
    
    func fullPhoto(withID id: String,
                   success: @escaping PhotoInfoCallback,
                   failure: @escaping ErrorCallback) {
        UnsplashPhoto.photo(
            withID: id,
            success: { [unowned self] photo in
                let availableInfo = photo.checkForAvailableInfo()
                let controllers = self.controllers(forPhotoInfo: availableInfo)
                success(photo, controllers)
            },
            failure: failure
        )
    }
    
    private func controllers(forPhotoInfo photoInfo: [PhotoInfoType]) -> CorrespondingInfoControllers {
        var photoInfoControllersDict: CorrespondingInfoControllers = [:]
        photoInfo.forEach { photoInfoType in
            guard let controller = photoInfoType.controllerTypeForInfo?.fromStoryboard() else {
                return
            }
            photoInfoControllersDict[photoInfoType] = controller
        }
        return photoInfoControllersDict
    }
    
}
