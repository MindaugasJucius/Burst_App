import UIKit
import BurstAPI

class PhotoDetailsDataController: NSObject {

    func fullPhoto(withID id: String,
                   success: @escaping PhotoCallback,
                   failure: @escaping ErrorCallback) {
        UnsplashPhoto.photo(
            withID: id,
            success: success,
            failure: failure
        )
    }
}
