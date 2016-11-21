extension UIViewController {
    
    func handle(error: Error) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: self,
            withError: error
        )
    }

}
