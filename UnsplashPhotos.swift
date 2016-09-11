//
//  UnsplashPhotos.swift
//  Burst
//
//  Created by Mindaugas Jucius on 21/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Unbox

typealias PhotosCallback = (photos: [Photo]?, error: NSError?) -> ()
typealias EmptyCallback = () -> ()
typealias ProgressCallback = (progress: Float) -> ()
typealias PhotoDownloadCallback = (response: Response<UIImage, NSError>, photo: Photo) -> ()

class UnsplashPhotos: NSObject {
    
    static let defaultInstance = UnsplashPhotos()
    
    private let networkGroup = dispatch_group_create()
    private let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .FIFO, maximumActiveDownloads: 1)

    func getPhotos(completionHandler: PhotosCallback, page: Int) -> [Photo]? {
        guard let appID = AppConstants.appConstDict[BurstID] else { return .None }
        Alamofire.request(.GET, UnsplashPhotosAll, parameters: [BurstID : appID, "page": String(page)]).responseJSON { [weak self] response in
            switch response.result {
            case .Success(let value):
                guard let photosJSON = value as? NSArray else { return }
                guard let strongSelf = self else { return }
                strongSelf.parsePhotoEntities(photosJSON, completionCallback: completionHandler)
            case .Failure(let error):
                completionHandler(photos: .None, error: error as NSError)
            }
        }
        return .None
    }
    
    private func parsePhotoEntities(photosJSON: NSArray, completionCallback: PhotosCallback) {
        do {
            var photos = [Photo]()
            try photosJSON.forEach({ (photoJSON) in
                guard let photo = photoJSON as? UnboxableDictionary else { return }
                let parsedPhoto: Photo = try Unbox(photo)
                dispatch_group_enter(networkGroup)
                getPhotoImage(parsedPhoto.urls.small, callback: { [weak self] (image, error) in
                    guard let strongSelf = self else { return }
                    guard let image = image else { return }
                    parsedPhoto.thumbImage = image
                    photos.append(parsedPhoto)
                    dispatch_group_leave(strongSelf.networkGroup)
                })
            })
            dispatch_group_notify(networkGroup, dispatch_get_main_queue(), {
                completionCallback(photos: photos, error: .None)
            })
        } catch let error {
            completionCallback(photos: .None, error: error as NSError)
        }
    }
    
    private func getPhotoImage(urlRequest: NSURL, callback: (image: UIImage?, error: NSError?) -> ()) {
        ImageDownloader.defaultInstance.downloadImage(URLRequest: NSURLRequest(URL: urlRequest)) { response in
            switch response.result {
            case .Success(let image):
                callback(image: image, error: .None)
            case .Failure(let error):
                callback(image: .None, error: error)
            }
        }
    }
    
    func addImageToQueueForDownload(photo: Photo, progressHandler: ProgressCallback, completion: PhotoDownloadCallback) {
        imageDownloader.downloadImage(URLRequest: NSURLRequest(URL: photo.urls.full), filter: .None,
            progress: { (bytesRead, totalBytesRead, totalExpectedBytesToRead) in
                let progress = Float(totalBytesRead) / Float(totalExpectedBytesToRead)
                progressHandler(progress: progress)
            },
            completion: { response in
                completion(response: response, photo: photo)
            }
        )
    }
    
}
