//
//  ViewController.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 20/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class PhotosController: UIViewController, UICollectionViewDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var dataSource: PhotosControllerDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add(_:)))
        collectionView.infiniteScrollIndicatorStyle = .White
        dataSource = PhotosControllerDataSource(collectionView: collectionView, viewController: self)
        let layout = PhotosWaterfallLayout()
        layout.itemRenderDirection = .RightToLeft
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @objc private func add(any: AnyObject) {
        print("whatsup")
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

