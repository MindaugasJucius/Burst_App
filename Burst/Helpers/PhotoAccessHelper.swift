import UIKit
import Photos
import BurstAPI

private struct AlertProperties {
    let message: String
    let okButtonTitle: String
}

private enum AlertState {
    case settings
    case popup
    
    var alertProperties: AlertProperties {
        switch self {
        case .settings:
            return AlertProperties(
                message: PhotoAccessSettings,
                okButtonTitle: SettingsApp
            )
        case .popup:
            return AlertProperties(
                message: PhotoAccessPopup,
                okButtonTitle: Ok
            )
        }
    }
}

class PhotoAccessHelper: NSObject {

    static let sharedInstance = PhotoAccessHelper()
    
    func askForPhotosAccessIfNecessary(withAskingController controller: UIViewController?, whenAuthorized authorized: EmptyCallback?,
        whenAuthorizationCancelled cancelled: EmptyCallback?) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        let settingsOkHandler = {
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings)
            }
        }
        
        let failureToGetAccess: EmptyCallback = { [weak self] in
            self?.askForPhotosAccessIfNecessary(withAskingController: controller, whenAuthorized: authorized, whenAuthorizationCancelled: cancelled)
        }
        
        let popupOkHandler: EmptyCallback = { [weak self] in
            self?.requestPhotoAuthorization(withSuccess: authorized, andFailure: failureToGetAccess)
        }
        
        switch status {
        case .authorized:
            authorized?()
        case .denied, .restricted:
            presentAlertForPhotoAccess(forState: .settings, onController: controller, withOkHandler: settingsOkHandler, withCancelHandler: cancelled)
        case .notDetermined:
            presentAlertForPhotoAccess(forState: .popup, onController: controller, withOkHandler: popupOkHandler, withCancelHandler: cancelled)
        }
    }
    
    fileprivate func requestPhotoAuthorization(withSuccess success: EmptyCallback?, andFailure failure: @escaping EmptyCallback) {
        PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .authorized:
                    success?()
                default:
                    failure()
                }
            }
        )
    }
    
    fileprivate func presentAlertForPhotoAccess(forState state: AlertState, onController controller: UIViewController?, withOkHandler okHandler: EmptyCallback?, withCancelHandler cancelHandler: EmptyCallback?) {
        AlertControllerPresenterHelper.sharedInstance.presentAlert(
            withMessage: state.alertProperties.message,
            andTitle: PhotoAccess,
            onController: controller,
            withOkMessage: state.alertProperties.okButtonTitle,
            withOkHandler: { alertAction in
                okHandler?()
            },
            withCancelHandler: { alertAction in
                cancelHandler?()
            }
        )
    }
    
}
