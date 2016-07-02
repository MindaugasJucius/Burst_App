//
//  ViewController.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 20/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import Photos
import CHTCollectionViewWaterfallLayout

class PhotosController: UIViewController, UICollectionViewDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: PhotosControllerDataSource?
    private var blurredCell: PhotoCellCollectionViewCell?
    
    private var progressWindow: UIWindow?
    private var progressView: PhotoDownloadProgressView?
    
    private var progressViewPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        collectionView.infiniteScrollIndicatorStyle = .White
        dataSource = PhotosControllerDataSource(collectionView: collectionView, viewController: self)
        
        let height = UIApplication.sharedApplication().statusBarFrame.height
        let width = UIScreen.mainScreen().bounds.width
        let frame = CGRectMake(0, 0, width, height)
        
        progressWindow = UIWindow(frame: frame)
        progressWindow?.windowLevel = UIWindowLevelStatusBar
        progressWindow?.backgroundColor = .clearColor()
        
        progressView = PhotoDownloadProgressView.createFromNib()
        progressView?.frame = CGRectMake(0, -height, width, height)
        
        
        let layout = PhotosWaterfallLayout()
        layout.itemRenderDirection = .RightToLeft
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        addTapGesture()
    }
    
    private func presentProgressViewWithCallback(presented: EmptyCallback) {
        guard let window = progressWindow else { return }
        guard let view = progressView else { return }
        progressWindow?.makeKeyAndVisible()
        window.addSubview(view)
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut,
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
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn,
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
    
    @objc private func tap(gesture: UITapGestureRecognizer) {
        dataSource?.clearCellBlur()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dataSource?.clearCellBlur()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    func askForPhotosAccess(success success: EmptyCallback, failure: EmptyCallback) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            success()
        case .Denied, .Restricted :
            presentViewController(alertForPhotoAccessSettings(), animated: true, completion: nil)
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .Authorized:
                    dispatch_async(dispatch_get_main_queue()) {
                        success()
                    }
                case .Denied, .Restricted:
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.presentViewController(strongSelf.alertForPhotoAccessSettings(), animated: true, completion: nil)
                    }
                case .NotDetermined:
                    print("This shouldn't happen.")
                }
            }
        }
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
                switch response.result {
                case .Success(let image):
                    self?.addPhotoToCameraRoll(image)
                    self?.progressView?.resetStateWithCount {
                        self?.hideProgressView()
                    }
                case .Failure(let error):
                    self?.presentErrorDownloadingPhotos(error)
                }
            }
        )
    }
    
    private func addPhotoToCameraRoll(image: UIImage) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            }, completionHandler: { [weak self] success, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.presentErrorDownloadingPhotos(error)
                    }
                }
                print("saved")
            }
        )
    }
    
    private func presentErrorDownloadingPhotos(error: NSError) {
        let alertController = UIAlertController(title: Error, message: error.localizedDescription, preferredStyle: .Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func alertForPhotoAccessSettings() -> UIAlertController {
        let alertController = UIAlertController(title: PhotoAccess, message: PhotoAccessSettings, preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: SettingsApp, style: .Default) { (alertAction) in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: Cancel, style: .Cancel, handler: .None)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension PhotosController: PhotosLayoutDelegate {

    func itemCount() -> Int {
        guard let dataSource = dataSource else { return Int.min }
        return dataSource.itemCount()
    }
    
    func heightForPhotoAtIndexPath(photoIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let dataSource = dataSource else { return CGFloat.min }
        return dataSource.itemSizeAtIndexPath(photoIndexPath: indexPath)
    }
    
}

extension PhotosController: CHTCollectionViewDelegateWaterfallLayout {

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        guard let dataSource = dataSource else { return CGSizeZero }
        let imageSize = dataSource.collectionViewItemSizeAtIndexPath(indexPath)
        
        return CGSizeMake(imageSize.width, imageSize.height)
    }

}

