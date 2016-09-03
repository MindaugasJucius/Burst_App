//
//  PhotosControllerDataSource.swift
//  Burst
//
//  Created by Mindaugas Jucius on 23/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PhotosControllerDataSource: NSObject, UICollectionViewDataSource {

    private let collectionView: UICollectionView
    private let viewController: PhotosCollectionViewController
    private var fetchedPhotos = [Photo]()
    private var currentPage = 1
    private var blurredCell: PhotoCellCollectionViewCell?
    
    var onDownloadPhoto: PhotoSaveCallback?
    
    init(collectionView: UICollectionView, viewController: PhotosCollectionViewController) {
        self.collectionView = collectionView
        self.viewController = viewController
        super.init()
        
        collectionView.addInfiniteScrollWithHandler { [weak self] collectionView in
            self?.retrievePhotosWithCompletion({ finished in
                collectionView.finishInfiniteScroll()
                collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        registerCollectionViewItems()
        retrievePhotosWithCompletion { finished in
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func registerCollectionViewItems() {
        let bundle = NSBundle.mainBundle()
        let cellNib = UINib.init(nibName: "PhotoCellCollectionViewCell", bundle: bundle)
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.registerNib(UINib.init(nibName: "CollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "RandomCell")
        let supplementaryNib = UINib.init(nibName: "PhotoDetailsSupplementaryView", bundle: bundle)
        collectionView.registerNib(supplementaryNib, forSupplementaryViewOfKind: PhotoDetailsSupplementaryViewKind, withReuseIdentifier: "PhotoDetails")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !fetchedPhotos.isEmpty else { return 0 }
        return fetchedPhotos.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        guard let photoCell = cell as? PhotoCellCollectionViewCell else { return cell }
        guard !fetchedPhotos.isEmpty else { return cell }
        let photo = fetchedPhotos[indexPath.row]
        photoCell.prepareForVisibility(photo)
        photoCell.onBlurFinish = { [weak self] cell in
            guard let strongSelf = self else { return }
            if let currentBlurredCell = strongSelf.blurredCell where currentBlurredCell != cell {
                currentBlurredCell.clearBlurWithCallback(.None)
            }
            strongSelf.blurredCell = cell
        }
        
        photoCell.onSaveTouch = { [weak self] photo in
            self?.downloadPhoto(photo)
        }
        
        return cell
    }
    
    private func retrievePhotosWithCompletion(completion: ((Bool) -> ())?) {
        UnsplashPhotos.defaultInstance.getPhotos({ [weak self] (photos, error) in
            self?.handlePhotosRetrieval(photos, error: error, completion: completion)
            }, page: currentPage)
    }
    
    private func downloadPhoto(photo: Photo) {
        viewController.downloadPhoto(photo)
    }
    
    func clearCellBlur() {
        blurredCell?.clearBlurWithCallback(.None)
        blurredCell = .None
    }

    private func handlePhotosRetrieval(photos: [Photo]?, error: NSError?, completion: ((Bool) -> ())?) {
        guard let photos = photos else {
            AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(onController: viewController, withError: error)
            collectionView.finishInfiniteScroll()
            return
        }
        
        var indexPaths = [NSIndexPath]()
        let index = self.fetchedPhotos.count
        
        // create index paths for affected items
        for photo in photos {
            let indexPath = NSIndexPath(forItem: index + 1, inSection: 0)
            
            indexPaths.append(indexPath)
            fetchedPhotos.append(photo)
        }
        //fetchedPhotos = photos
        
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completion: completion)
        currentPage = currentPage + 1
    }
    
}

extension PhotosControllerDataSource {
    
    func collectionViewItemSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        guard !fetchedPhotos.isEmpty else { return CGSizeZero }
        guard let image = fetchedPhotos[indexPath.item].thumbImage else { return CGSizeZero }
        return CGSizeMake(image.size.width, image.size.height)
    }
    
    func itemSizeAtIndexPath(photoIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard !fetchedPhotos.isEmpty else { return 0 }
        guard let image = fetchedPhotos[indexPath.item].thumbImage else { return 0 }
        return image.size.height
    }
    
    func itemCount() -> Int {
        return fetchedPhotos.count
    }
    
}

