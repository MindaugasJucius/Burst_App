import UIKit
import Photos
import BurstAPI

private let AlbumPredicate = "title = %@"

class PhotoSavingHelper: NSObject {

    private let controller: UIViewController
    
    private var photosToSave: [UIImage] = []
    private var assetCollection: PHAssetCollection?
    private var collection: PHAssetCollection?
    
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
    
    private func addPhotoToAlbum(image: UIImage) {
        guard let index = photosToSave.indexOf(image) else {
            return
        }
        photosToSave.removeAtIndex(index)
        createAlbumIfNeeded(withSuccess: { [weak self] in
                self?.createPhoto(fromImage: image)
            },
            andFailure: {
                print("lol")
            }
        )
        
    }
    
    private func createPhoto(fromImage image: UIImage) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ [weak self] in
                guard let album = self?.assetCollection else {
                    return
                }
                let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                let assetPlaceholder = assetRequest.placeholderForCreatedAsset
                guard let placeholder = assetPlaceholder else {
                    return
                }
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: album)
                albumChangeRequest?.addAssets([placeholder])
            },
            completionHandler: { [weak self] success, error in
                if let error = error {
                    self?.presentError(error)
                }
            }
        )
    }
    
    private func createAlbumIfNeeded(withSuccess created: EmptyCallback, andFailure failure: EmptyCallback) {
        //Get PHFetch Options
        let fetchOptions = PHFetchOptions()
        var assetCollectionPlaceholder: PHObjectPlaceholder = PHObjectPlaceholder()
        
        fetchOptions.predicate = NSPredicate(format: AlbumPredicate, APPName)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album,
            subtype: .Any,
            options: fetchOptions
        )
        
        //Check return value - If found, then get the first album out
        if let availableCollection = collection.firstObject as? PHAssetCollection {
            assetCollection = availableCollection
            created()
            return
        }
        
        //If not found - Then create a new album
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(APPName)
                assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            },
            completionHandler: { [weak self] success, error in
                guard success else {
                    self?.presentError(error)
                    failure()
                    return
                }
                let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers(
                    [assetCollectionPlaceholder.localIdentifier],
                    options: nil
                )
                self?.assetCollection = collectionFetchResult.firstObject as? PHAssetCollection
                created()
            }
        )
    }
    
    private func presentError(error: NSError?) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: controller,
            withError: error
        )
    }
}
