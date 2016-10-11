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
import BurstAPI

class PhotosControllerDataSource: NSObject, UICollectionViewDataSource {

    fileprivate let collectionView: UICollectionView
    fileprivate let viewController: PhotosCollectionViewController
    fileprivate var fetchedPhotos = [Photo]()
    fileprivate var currentPage = 1
    fileprivate var blurredCell: PhotoCellCollectionViewCell?
    
    var onDownloadPhoto: PhotoSaveCallback?
    
    init(collectionView: UICollectionView, viewController: PhotosCollectionViewController) {
        self.collectionView = collectionView
        self.viewController = viewController
        super.init()
        
        collectionView.addInfiniteScroll { [weak self] collectionView in
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
    
    fileprivate func registerCollectionViewItems() {
        let bundle = Bundle.main
        let cellNib = UINib.init(nibName: "PhotoCellCollectionViewCell", bundle: bundle)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "RandomCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !fetchedPhotos.isEmpty else { return 0 }
        return fetchedPhotos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        guard let photoCell = cell as? PhotoCellCollectionViewCell else { return cell }
        guard !fetchedPhotos.isEmpty else { return cell }
        let photo = fetchedPhotos[indexPath.row]
        photoCell.prepareForVisibility(photo)
        photoCell.onBlurFinish = { [weak self] cell in
            guard let strongSelf = self else { return }
            if let currentBlurredCell = strongSelf.blurredCell , currentBlurredCell != cell {
                currentBlurredCell.clearBlurWithCallback(.none)
            }
            strongSelf.blurredCell = cell
        }
        
        photoCell.onSaveTouch = { [weak self] photo in
            self?.downloadPhoto(photo)
        }
        
        return cell
    }
    
    fileprivate func retrievePhotosWithCompletion(_ completion: ((Bool) -> ())?) {
        UnsplashPhotos.defaultInstance.getPhotos({ [weak self] (photos, error) in
            self?.handlePhotosRetrieval(photos, error: error, completion: completion)
            }, page: currentPage)
    }
    
    fileprivate func downloadPhoto(_ photo: Photo) {
        viewController.downloadPhoto(photo)
    }
    
    func clearCellBlur() {
        blurredCell?.clearBlurWithCallback(.none)
        blurredCell = .none
    }

    fileprivate func handlePhotosRetrieval(_ photos: [Photo]?, error: NSError?, completion: ((Bool) -> ())?) {
        guard let photos = photos else {
            AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(onController: viewController, withError: error)
            collectionView.finishInfiniteScroll()
            return
        }
        
        var indexPaths = [IndexPath]()
        let index = self.fetchedPhotos.count
        
        // create index paths for affected items
        for photo in photos {
            let indexPath = IndexPath(item: index + 1, section: 0)
            indexPaths.append(indexPath)
            fetchedPhotos.append(photo)
        }
        //fetchedPhotos = photos
        
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.insertItems(at: indexPaths)
            }, completion: completion)
        currentPage = currentPage + 1
    }
    
}

extension PhotosControllerDataSource {
    
    func collectionViewItemSizeAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        guard !fetchedPhotos.isEmpty else { return CGSize.zero }
        guard let image = fetchedPhotos[indexPath.item].thumbImage else { return CGSize.zero }
        return CGSize(width: image.size.width, height: image.size.height)
    }
    
    func itemSizeAtIndexPath(photoIndexPath indexPath: IndexPath) -> CGFloat {
        guard !fetchedPhotos.isEmpty else { return 0 }
        guard let image = fetchedPhotos[indexPath.item].thumbImage else { return 0 }
        return image.size.height
    }
    
    func itemCount() -> Int {
        return fetchedPhotos.count
    }
    
}

