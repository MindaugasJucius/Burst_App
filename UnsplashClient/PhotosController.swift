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
        progressWindow?.makeKeyAndVisible()
        
        progressView = PhotoDownloadProgressView.createFromNib()
        //progressView?.frame = frame
        
        
        let layout = PhotosWaterfallLayout()
        layout.itemRenderDirection = .RightToLeft
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        addTapGesture()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presentProgressView()
    }
    
    private func presentProgressView() {
        guard let window = progressWindow else { return }
        guard let view = progressView else { return }
        var progressWindowFrame = window.frame
        progressWindowFrame.origin.y -= progressWindowFrame.height
        progressView?.frame = progressWindowFrame
        window.addSubview(view)
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseOut,
            animations: {
                view.frame = window.frame
            },
            completion: .None)
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

