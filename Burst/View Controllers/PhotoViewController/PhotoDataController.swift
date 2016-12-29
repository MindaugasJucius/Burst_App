import BurstAPI

typealias CorrespondingInfoControllers = [PhotoInfoType: UIViewController]
typealias CorrespondingInfoViews = [PhotoInfoType: UIView]
typealias PhotoInfoCallback = (_ photo: Photo) -> ()

protocol PhotoInfoContentController: class {
    func contentHeight() -> CGFloat
}

extension PhotoInfoType {
    
    var controllerTypeForInfo: UIViewController.Type? {
        switch self {
        case .author:
            return AuthorViewController.self
        case .location:
            return LocationViewController.self
        case .categories:
            return PhotoCategoryViewController.self
        default:
            return nil
        }
    }
    
    var controllerForInfo: UIViewController? {
        return controllerTypeForInfo?.fromStoryboard()
    }
    
}

class PhotoDataController: NSObject {

    var infoViews: CorrespondingInfoViews = [:]
    var infoControllers: CorrespondingInfoControllers = [:]
    
    func fullPhoto(withID id: String,
                   success: @escaping PhotoInfoCallback,
                   failure: @escaping ErrorCallback) {
        let singlePhotoURL = String(format: UnsplashSinglePhotoURL, id)
        UnsplashGeneric.unsplash(
            getFromURL: URL(string: singlePhotoURL)!,
            success: { [unowned self] (photo: Photo) in
                self.infoControllers = self.controllers(forPhoto: photo)
                success(photo)
            },
            failure: failure
        )
    }
    
    func contentHeight(forInfoType infoType: PhotoInfoType) -> CGFloat {
        switch infoType {
        case .author, .location, .categories:
            guard let controller = infoControllers[infoType] as? PhotoInfoContentController else {
                return TableViewCellDefaultHeight
            }
            return controller.contentHeight()
        default:
            return TableViewCellDefaultHeight
        }
    }
    
    func contentHeight() -> CGFloat {
        return Array(infoControllers.values).reduce(0 as CGFloat) { partialResult, element in
            guard let contentController = element as? PhotoInfoContentController else {
                    return partialResult
            }
            return partialResult + contentController.contentHeight()
        }
    }
    
    private func controllers(forPhoto photo: Photo) -> CorrespondingInfoControllers {
        let photoInfo = photo.checkForAvailableInfo()
        var photoInfoControllersDict: CorrespondingInfoControllers = [:]
        photoInfo.forEach { [unowned self] photoInfoType in
            switch photoInfoType {
            case .author:
                guard let authorType = photoInfoType.controllerTypeForInfo as? AuthorViewController.Type,
                    let controller = authorType.instantiate(forPhotoDetails: true) else {
                        return
                }
                controller.user = photo.uploader
                photoInfoControllersDict[photoInfoType] = controller
                self.infoViews[photoInfoType] = controller.view
            case .location:
                guard let location = photo.location else {
                    return
                }
                let controller = LocationViewController(location: location)
                photoInfoControllersDict[photoInfoType] = controller
                self.infoViews[photoInfoType] = controller.view
            case .categories:
                guard let photoCategories = photo.categories else {
                    return
                }
                let controller = PhotoCategoryViewController(photoCategories: photoCategories)
                photoInfoControllersDict[photoInfoType] = controller
                self.infoViews[photoInfoType] = controller.view
            default:
                return
            }
        }
        return photoInfoControllersDict
    }
    
}
