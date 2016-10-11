import UIKit
import Photos
import BurstAPI

private let AlbumPredicate = "title = %@"

class PhotoSavingHelper: NSObject {

    fileprivate let controller: UIViewController
    
    fileprivate var photosToSave: [UIImage] = []
    fileprivate var assetCollection: PHAssetCollection?
    fileprivate var collection: PHAssetCollection?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func save(imageToSave image: UIImage) {
        photosToSave.append(image)
        let success = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.photosToSave.forEach({ image in
                    strongSelf.addPhotoToAlbum(image)
                }
            )
        }
        
        let cancelled: EmptyCallback = { [weak self] in
            self?.photosToSave = []
        }
        
        PhotoAccessHelper.sharedInstance.askForPhotosAccessIfNecessary(
            withAskingController: controller,
            whenAuthorized: success,
            whenAuthorizationCancelled: cancelled
        )
    }
    
    fileprivate func addPhotoToAlbum(_ image: UIImage) {
        guard let index = photosToSave.index(of: image) else {
            return
        }
        photosToSave.remove(at: index)
        createAlbumIfNeeded(withSuccess: { [weak self] in
                self?.createPhoto(fromImage: image)
            },
            andFailure: {
                print("lol")
            }
        )
        
    }
    
    fileprivate func createPhoto(fromImage image: UIImage) {
        PHPhotoLibrary.shared().performChanges({ [weak self] in
                guard let album = self?.assetCollection else {
                    return
                }
                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceholder = assetRequest.placeholderForCreatedAsset
                guard let placeholder = assetPlaceholder else {
                    return
                }
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([placeholder])
            },
            completionHandler: { [weak self] success, error in
                if let error = error {
                    self?.presentError(error as NSError?)
                }
            }
        )
    }
    
    fileprivate func createAlbumIfNeeded(withSuccess created: EmptyCallback, andFailure failure: EmptyCallback) {
        //Get PHFetch Options
        let fetchOptions = PHFetchOptions()
        var assetCollectionPlaceholder: PHObjectPlaceholder = PHObjectPlaceholder()
        
        fetchOptions.predicate = NSPredicate(format: AlbumPredicate, APPName)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album,
            subtype: .any,
            options: fetchOptions
        )
        
        //Check return value - If found, then get the first album out
        if let availableCollection = collection.firstObject as? PHAssetCollection {
            assetCollection = availableCollection
            created()
            return
        }
        
        //If not found - Then create a new album
        PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: APPName)
                assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            },
            completionHandler: { [weak self] success, error in
                guard success else {
                    self?.presentError(error as NSError?)
                    failure()
                    return
                }
                let collectionFetchResult = PHAssetCollection.fetchAssetCollections(
                    withLocalIdentifiers: [assetCollectionPlaceholder.localIdentifier],
                    options: nil
                )
                self?.assetCollection = collectionFetchResult.firstObject as? PHAssetCollection
                created()
            }
        )
    }
    
    fileprivate func presentError(_ error: NSError?) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: controller,
            withError: error
        )
    }
}
