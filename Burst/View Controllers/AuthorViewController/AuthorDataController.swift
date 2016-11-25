import BurstAPI
import UIKit
import Unbox

typealias UserInfoTuple = (collections: [PhotoCollection]?, photos: [Photo]?)

class AuthorDataController: NSObject {

    private let user: User
    private let onError: ErrorCallback
    
    init(user: User, onError: @escaping ErrorCallback) {
        self.user = user
        self.onError = onError
        super.init()
    }
    
    
    func fetchUserInfo(success: @escaping (UserInfoTuple) -> ()) {
        var userInfo = UserInfoTuple(collections: nil, photos: nil)
        let fetchGroup = DispatchGroup()
        let onDispatchGroupError: (Error) -> () = { [unowned self] error in
            fetchGroup.leave()
            self.onError(error)
        }
        if let userCollectionsLink = user.usersCollectionsLink {
            fetchGroup.enter()
            fetch(url: userCollectionsLink,
                success: { (photoCollections: [PhotoCollection]) in
                    fetchGroup.leave()
                    userInfo.collections = photoCollections
                },
                failure: onDispatchGroupError
            )
        }
        fetchGroup.enter()
        fetch(url: user.userProfileLinks.photos,
            success: { (photos: [Photo]) in
                fetchGroup.leave()
                userInfo.photos = photos
            },
            failure: onDispatchGroupError
        )
        fetchGroup.notify(queue: DispatchQueue.main,
            execute: {
                success(userInfo)
            }
        )
    }
    
    private func fetch<U: Unboxable>(url: URL, success: @escaping EntityArrayCallback<U>, failure: @escaping ErrorCallback) {
        UnsplashGeneric.unsplash(getFromURL: url, success: success, failure: failure)
    }
    
}
