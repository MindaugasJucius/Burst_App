import UIKit
import Photos

// progress viewa isvis i sita nukelt
// arba padaryt kad ant celiu rodytu progresa
protocol ContainerControllerDelegate: class {
    func photoPermissionsGranted() -> Bool
    func downloadPhoto(photo: Photo) //grazini success ir tada ta cele pakeicia savo busena ;]
}

extension ContainerControllerDelegate where Self: UIViewController { }

protocol ContainerAlerts { }

class ContainerViewController: UIViewController {

    private var contentViewController: UIViewController?
    private var progressWindow: UIWindow?
    private var progressView: PhotoDownloadProgressView?
    
    private var progressViewPresented = false
    private var photosToSave: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = APPName
        navigationController?.navigationBar.translucent = false
        
        let height = UIApplication.sharedApplication().statusBarFrame.height
        let width = UIScreen.mainScreen().bounds.width
        let frame = CGRectMake(0, 0, width, height)
        
        progressWindow = UIWindow(frame: frame)
        progressWindow?.windowLevel = UIWindowLevelStatusBar
        progressWindow?.backgroundColor = .clearColor()
        
        progressView = PhotoDownloadProgressView.createFromNib()
        progressView?.frame = CGRectMake(0, -height, width, height)
    }
    
    override func viewWillAppear(animated: Bool) {
        //settingsStoreGetPreferredVC
        let controller = PhotosCollectionViewController(nibName: "PhotosCollectionViewController", bundle: nil)
        contentViewController = controller
        controller.delegate = self
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMoveToParentViewController(self)
        navigationController?.viewControllers = [controller]
    }
    
    private func addPhotoToDownloadQueue(photo: Photo) {
        guard let progressView = progressView else { return }
        progressView.addDownloadItem()
        UnsplashPhotos.defaultInstance.addImageToQueueForDownload(photo,
            progressHandler: { (progress) in
                if !progressView.updatedState {
                    progressView.addCurrentItem()
                }
                progressView.setProgress(progress)
            },
            completion: { [weak self] response, photo in
                guard let strongSelf = self else {
                    return
                }
                switch response.result {
                case .Success(let image):
                    print(response.response?.statusCode)
                    strongSelf.save(imageToSave: image)
                    strongSelf.progressView?.resetStateWithCount {
                        strongSelf.hideProgressView()
                    }
                case .Failure(let error):
                    strongSelf.presentError(error)
                }
            }
        )
    }
    
    private func presentProgressViewWithCallback(presented: EmptyCallback) {
        guard let window = progressWindow else { return }
        guard let view = progressView else { return }
        progressWindow?.makeKeyAndVisible()
        window.addSubview(view)
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: .CurveEaseOut,
            animations: {
                view.frame = window.frame
            },
            completion: { finished in
                if finished {
                    presented()
                }
            }
        )
    }
    
    private func hideProgressView() {
        guard let window = progressWindow else { return }
        guard let view = progressView else { return }
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: .CurveEaseIn,
            animations: {
                view.frame.origin.y -= view.frame.height
            },
            completion: { [weak self] finished in
                if finished {
                    self?.progressViewPresented = false
                    window.hidden = true
                }
            }
        )
    }
    
    private func save(imageToSave image: UIImage) {
        photosToSave.append(image)
        let success = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.photosToSave.forEach({ image in
                    strongSelf.addPhotoToCameraRoll(image)
                }
            )
        }
        
        let cancelled: EmptyCallback = { [weak self] in
            self?.photosToSave = []
        }
        
        PhotoAccessHelper.sharedInstance.askForPhotosAccessIfNecessary(
            withAskingController: self.contentViewController,
            whenAuthorized: success,
            whenAuthorizationCancelled: cancelled
        )
    }
    
    private func addPhotoToCameraRoll(image: UIImage) {
        guard let index = photosToSave.indexOf(image) else {
            return
        }
        photosToSave.removeAtIndex(index)
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            },
            completionHandler: { [weak self] success, error in
                if let error = error {
                    self?.presentError(error)
                }
            }
        )
    }
    
}

extension ContainerViewController: ContainerAlerts {
    
    private func presentError(error: NSError) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: self.contentViewController,
            withError: error
        )
    }
}

extension ContainerViewController: ContainerControllerDelegate {

    func photoPermissionsGranted() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .Authorized
    }
    
    func downloadPhoto(photo: Photo) {
        guard progressViewPresented else {
            presentProgressViewWithCallback { [weak self] in
                self?.progressViewPresented = true
                self?.addPhotoToDownloadQueue(photo)
            }
            return
        }
        addPhotoToDownloadQueue(photo)
    }
    
}
