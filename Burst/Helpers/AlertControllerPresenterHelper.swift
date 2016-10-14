import UIKit

typealias ActionHandlerCallback = (UIAlertAction) -> ()

class AlertControllerPresenterHelper: NSObject {
    
    static let sharedInstance = AlertControllerPresenterHelper()
    
    func presentErrorAlert(onController controller: UIViewController?, withError error: NSError?) {
        let errorAlertController = UIAlertController(
            title: Error,
            message: error?.localizedDescription ?? Error,
            preferredStyle: .alert
        )
        presentIfPossible(
            presentingController: controller,
            controllerToPresent: errorAlertController
        )
    }
    
    func presentAlert(withMessage message: String?,
        andTitle title: String?,
        onController controller: UIViewController?,
        withOkMessage okMessage: String = Ok,
        withOkHandler okHandler: ActionHandlerCallback?,
        withCancelHandler cancelHandler: ActionHandlerCallback?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction(andTitle: okMessage, withHandler: okHandler))
        alertController.addAction(cancelAction(withHandler: cancelHandler))
        presentIfPossible(presentingController: controller, controllerToPresent: alertController)
    }
    
    fileprivate func cancelAction(withHandler handler: ActionHandlerCallback?) -> UIAlertAction {
        return UIAlertAction(title: Cancel, style: .cancel, handler: handler)
    }
    
    fileprivate func okAction(andTitle title: String, withHandler handler: ActionHandlerCallback?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }
    
    fileprivate func presentIfPossible(presentingController controller: UIViewController?, controllerToPresent: UIViewController) {
        guard let controller = controller , controller.presentedViewController == nil else {
            return
        }
        DispatchQueue.main.async(execute: {
                controller.present(
                    controllerToPresent,
                    animated: true,
                    completion: nil
                )
            }
        )
    }
    
}