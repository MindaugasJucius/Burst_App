import UIKit

typealias ActionHandlerCallback = (UIAlertAction) -> ()

class AlertControllerPresenterHelper: NSObject {
    
    static let sharedInstance = AlertControllerPresenterHelper()
    
    func presentErrorAlert(onController controller: UIViewController?, withError error: NSError?) {
        let errorAlertController = UIAlertController(
            title: Error,
            message: error?.localizedDescription ?? Error,
            preferredStyle: .Alert
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
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(okAction(andTitle: okMessage, withHandler: okHandler))
        alertController.addAction(cancelAction(withHandler: cancelHandler))
        presentIfPossible(presentingController: controller, controllerToPresent: alertController)
    }
    
    private func cancelAction(withHandler handler: ActionHandlerCallback?) -> UIAlertAction {
        return UIAlertAction(title: Cancel, style: .Cancel, handler: handler)
    }
    
    private func okAction(andTitle title: String, withHandler handler: ActionHandlerCallback?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Default, handler: handler)
    }
    
    private func presentIfPossible(presentingController controller: UIViewController?, controllerToPresent: UIViewController) {
        guard let controller = controller where controller.presentedViewController == nil else {
            return
        }
        dispatch_async(dispatch_get_main_queue(), {
                controller.presentViewController(
                    controllerToPresent,
                    animated: true,
                    completion: nil
                )
            }
        )
    }
    
}
